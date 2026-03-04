# Challenge iOS – Space Flight News

Aplicación iOS desarrollada como parte del challenge técnico para Mercado Libre. Consume la API pública de [Spaceflight News](https://api.spaceflightnewsapi.net/v4/docs/) para listar, buscar y visualizar artículos sobre noticias del espacio.

La app está construida sobre **UIKit** con un **Coordinator** que gestiona la navegación y embebe las vistas **SwiftUI** mediante `UIHostingController`. Esta decisión fue intencional para demostrar dominio de ambos frameworks y cómo pueden convivir en un mismo proyecto.

Funcionalidades principales:
* Listado paginado de artículos recientes.
* Búsqueda de artículos con debounce.
* Pantalla de detalle con información completa del artículo.
* Retroalimentación visual ante errores de red y estados vacíos.
* Splash screen animada con **Lottie**.

---

## Dependencias y Configuración

El proyecto utiliza [CocoaPods](https://cocoapods.org) como gestor de dependencias. La única librería externa es **lottie-ios**, empleada para reproducir la animación del launch screen (un cohete despegando).

Para instalar las dependencias y ejecutar el proyecto:

```bash
# 1. Clonar el repositorio
git clone <url-del-repo>
cd ChallengeMeli-iOS

# 2. Instalar las dependencias con CocoaPods
pod install

# 3. Abrir el workspace (NO el .xcodeproj)
open ChallengeMeli-iOS.xcworkspace
```

> **Nota:** Es necesario tener CocoaPods instalado. Si no lo tenés, podés instalarlo con `sudo gem install cocoapods` o `brew install cocoapods`.

---

## Decisiones Técnicas y Arquitectura

Se documentan a continuación las decisiones de diseño alineadas con los criterios de evaluación del challenge:

### 1. Arquitectura y Patrones de Diseño

La aplicación adopta **MVVM** como patrón de presentación, apoyándose en principios de **Clean Architecture** para organizar las capas del sistema. El flujo de navegación inicial se delega a un **Coordinator**.

* **Capa de Vista (SwiftUI):** `ArticleListView` y `ArticleDetailView` son structs genéricos parametrizados sobre protocolos de ViewModel (por ejemplo `<ViewModel: ArticleListViewModelProtocol>`). Esto desacopla las vistas de las implementaciones concretas, habilitando la sustitución por mocks en tiempo de test o en previews de Xcode.
* **Capa de ViewModel:** `ArticleListViewModel` y `ArticleDetailViewModel` encapsulan la lógica de presentación. El estado de cada pantalla se modela con enums dedicados (`ArticleListState` con casos `.idle`, `.loading`, `.error`, `.empty`, `.data`; y `ArticleDetailState` con `.idle`, `.loading`, `.error`, `.loaded`), expuestos mediante propiedades `@Published`. Ambos están anotados con `@MainActor` para asegurar que las mutaciones de estado se ejecuten siempre en el hilo principal.
* **Capa de Casos de Uso:** `ListArticlesUseCase`, `SearchArticlesUseCase` y `ArticleDetailUseCase` representan operaciones de dominio individuales. Cada uno recibe su dependencia como protocolo (`SpaceFlightRepositoryProtocol`) vía inyección en el `init`, respetando el principio de inversión de dependencias.
* **Capa de Repositorio:** El protocolo `SpaceFlightRepositoryProtocol` define el contrato de acceso a datos. Su implementación concreta, `SpaceFlightRepository`, coordina las llamadas al `NetworkClient` y retorna los DTOs correspondientes.
* **Capa de Networking:** Se construyó un módulo de red reutilizable compuesto por un protocolo `NetworkClientProtocol` con un método genérico `request<T: Decodable>(endpoint:)`, y un protocolo `Endpoint` que proporciona valores por defecto (base URL, versión de API) a través de una extension. El enum `SpaceFlightEndpoint` define los tres endpoints concretos de la API (listado, búsqueda y detalle). Toda la comunicación es asíncrona con `async/await`.
* **Coordinator (UIKit):** `AppCoordinator` es el punto de entrada de la navegación y está escrito íntegramente en UIKit. Controla la secuencia de arranque: presenta primero un `SplashViewController` (UIKit + **Lottie**) y, cuando la animación termina, instancia las vistas SwiftUI y las embebe dentro de un `UINavigationController` a través de `UIHostingController`. De esta forma, la capa de coordinación vive en UIKit mientras que la capa de presentación aprovecha la declaratividad de SwiftUI, demostrando cómo integrar ambos frameworks de manera cohesiva.

Gracias a esta organización por capas, cada componente se puede testear de manera aislada: los ViewModels se prueban inyectando UseCases mockeados, y los UseCases se prueban con un Repositorio mock.

### 2. Manejo de Errores (Punto de Vista del Usuario)

La aplicación prioriza que el usuario reciba retroalimentación clara en cualquier escenario adverso. Para ello se creó `FeedbackView`, un componente reutilizable con factory methods estáticos que genera la pantalla de feedback adecuada:

* **Sin conexión a Internet:** Cuando la solicitud falla por un problema de conectividad, se presenta un ícono de `wifi.slash` acompañado del título "Sin conexión" y un texto que invita al usuario a verificar su conexión.
* **Recurso no encontrado:** Ante un error de servidor (status 400-502), se despliega un ícono de lupa junto al mensaje "No encontrado" y una descripción orientativa.
* **Resultados vacíos en la búsqueda:** Si el usuario busca un término que no arroja coincidencias, se muestra "No se encontraron resultados" junto con la query ingresada, para que sepa exactamente qué se buscó.
* **Indicadores de actividad:** Mientras se realizan peticiones, se presenta un `ProgressView` tanto en la carga inicial del listado como durante la paginación (al pie de la lista) y al abrir el detalle. Esto asegura que el usuario perciba que la app está procesando su solicitud.

### 3. Manejo de Errores (Punto de Vista del Developer)

* **Tipificación de errores de red:** Se definió el enum `ServiceError` (conforme a `Error`) con dos variantes: `.notFountError` para status codes entre 400 y 502, y `.conexionError` para fallos de conectividad o cualquier error no catalogado. La conversión desde el status code HTTP se centraliza en un `init(_ response: Int?)`, evitando lógica de mapeo dispersa.
* **Propagación hacia arriba:** Los errores fluyen desde `NetworkClient` → `SpaceFlightRepository` → UseCase → ViewModel utilizando `throws` en cada capa, sin transformarlos ni absorberlos prematuramente.
* **Manejo en los ViewModels:** Tanto `ArticleListViewModel` como `ArticleDetailViewModel` ejecutan sus llamadas dentro de `Task` con bloques `do/catch`. Si el error capturado es de tipo `ServiceError`, se asigna directamente al estado; cualquier otro error se traduce a `.conexionError`. La vista, al observar el cambio de estado mediante un `switch`, renderiza el `FeedbackView` correspondiente de forma automática.

### 4. Calidad del Proyecto (Tests Unitarios)

El proyecto cuenta con un target de testing (`ChallengeMeli-iOSTests`) orientado a validar la lógica de negocio y presentación sin depender de la interfaz gráfica.

* **Mocks de dependencias:** Se implementaron dobles de prueba para cada abstracción relevante: `MockListArticlesUseCase`, `MockSearchArticlesUseCase`, `MockArticleDetailUseCase`, `MockSpaceFlightRepository` y `MockNetworkClient`. Estos permiten controlar las respuestas y simular escenarios de error.
* **ViewModels:** `ArticleListViewModelTests` cubre los flujos principales:
    * Verifica que una carga exitosa transicione el estado a `.data` con los artículos publicados.
    * Valida que un error de red lleve al estado `.error`.
    * Confirma que el debounce de 500ms sobre el texto de búsqueda dispare el caso de uso correcto.
    * `ArticleListViewModelPaginationTests` ejercita el infinite scroll: carga adicional cuando el usuario se acerca al final (últimos 5 ítems), prevención de fetch cuando `canLoadMore` es `false`, y verificación de que ítems lejanos al final no disparen la carga.
* **Casos de Uso:** `ListArticlesUseCaseTests`, `SearchArticlesUseCaseTests` y `ArticleDetailUseCaseTests` aseguran que el mapeo de DTOs a modelos de dominio sea correcto y que los errores del repositorio se propaguen intactos.
* **DTOs y Modelos:** `DTODecodingTests` comprueba la decodificación JSON respetando `CodingKeys` (snake_case a camelCase) y la simetría encode/decode. `ArticleResponseModelTests` valida la transformación completa del DTO paginado al modelo de dominio, incluyendo autores y parseo de fechas.
* **Networking:** `SpaceFlightEndpointTests` verifica paths, métodos HTTP, parámetros de query y construcción de URLs. `ServiceErrorTests` evalúa la clasificación de status codes. `SpaceFlightRepositoryTests` confirma que el repositorio seleccione el endpoint adecuado y retransmita tanto resultados como errores.
* **Utilidades:** `DateFormatterExtensionTests` testea la conversión de strings ISO 8601 a `Date`. `FeedbackViewFactoryTests` recorre todos los factory methods comprobando la generación correcta de cada variante.

Los tests de ViewModels se ejecutan con la anotación `@MainActor` para replicar las condiciones reales de ejecución.

### 5. Diseño de Layouts y Rotación

* **Framework de UI:** La interfaz se construyó íntegramente con SwiftUI. El único punto de contacto con UIKit es `UIHostingController`, utilizado por el Coordinator para embeber las vistas SwiftUI dentro del flujo de navegación.
* **Composición de layouts:** Las pantallas emplean `NavigationStack`, `ScrollView`, `LazyVStack`, `VStack` y `HStack` para organizar el contenido de forma flexible y que se ajuste al tamaño disponible.
* **Componentes compartidos:** Se extrajeron piezas reutilizables: `RemoteImageView` (envuelve `AsyncImage` y provee un placeholder por defecto con `Image(systemName: "photo")`), `FeedbackView` (pantalla de feedback parametrizable con factory methods), `SectionView` (encabezado con lista horizontal de ítems) y `ArticleListRow` (celda de artículo estilizada con sombra y bordes redondeados).
* **Descarga asíncrona de imágenes:** Las imágenes remotas se cargan a través de `AsyncImage` encapsulado en `RemoteImageView`, mostrando un placeholder mientras se resuelve la descarga.
* **Animación de inicio:** Al arrancar la app se muestra una splash screen con una animación de Lottie (cohete despegando), integrada vía CocoaPods. Cuando la animación finaliza, se transiciona al listado de artículos.

### 6. Uso de la Memoria

* **Gestión del ciclo de vida de los ViewModels:** `ArticleDetailView` crea su ViewModel con `@StateObject`, garantizando que la instancia persista durante todo el ciclo de vida de la vista y se libere al destruirla. `ArticleListView`, en cambio, recibe su ViewModel desde el Coordinator y lo observa con `@ObservedObject`, delegando la propiedad de la instancia al nivel superior.
* **Suscripciones de Combine:** `ArticleListViewModel` almacena la suscripción al publisher `$searchText` (con debounce de 500 ms) en un `Set<AnyCancellable>`. Al desinicializarse el ViewModel, las suscripciones se cancelan automáticamente junto con sus `AnyCancellable`, previniendo fugas de memoria.
* **Cancelación explícita de Tasks:** `ArticleDetailViewModel` guarda una referencia a `loadTask: Task<Void, Never>?`. Si el usuario abandona la pantalla de detalle antes de que la carga termine, el `deinit` cancela la task de forma explícita para detener trabajo en segundo plano que ya no tiene sentido.
* **Carga progresiva de datos:** El listado implementa paginación con lotes de 20 artículos. La función `loadMoreIfNeeded` se activa solamente cuando el artículo visible está entre los últimos 5 de la lista, evitando descargar grandes volúmenes de datos innecesariamente. La bandera `canLoadMore` se determina evaluando si la respuesta de la API contiene un enlace `next`.

### 7. Permisos del Sistema Operativo

La app solicita permiso de notificaciones push al iniciar.

El componente `NotificationPermissionManager` consulta el estado actual de autorización y, únicamente cuando es `.notDetermined`, presenta la solicitud de permiso al usuario. Si la autorización es concedida, se invoca `registerForRemoteNotifications()` para habilitar notificaciones remotas. Este comportamiento respeta al usuario (no vuelve a pedir si ya denegó el permiso) y deja la infraestructura lista para incorporar notificaciones en futuras iteraciones, como alertar sobre artículos nuevos de interés.
