# Análisis de la implementación

## 1. Splash: `@State` frente a `@StateObject`
`isActive` es un `Bool` local que solo controla la animación de esta vista.
SwiftUI conserva su valor mientras mantiene la identidad de `SplashView`.
`@StateObject` se reserva para una instancia de referencia que implementa `ObservableObject`.
Crear un objeto observable para un único indicador añadiría complejidad innecesaria.
La navegación se delega al contenedor cuando termina `Task.sleep`.

## 2. Login: binding frente a copia
`$viewModel.email` entrega un `Binding<String>` de lectura y escritura al campo.
Cada pulsación actualiza la propiedad `@Published` del ViewModel y refresca la interfaz.
Pasar `viewModel.email` solo entrega el texto actual, sin canal para escribir cambios.
Por ejemplo, `TextField("Correo", text: $viewModel.email)` sí edita el estado original.
Esto permite habilitar el botón y validar el valor actualizado.

## 3. Registro: `@EnvironmentObject`
`SessionStore` comparte usuarios y sesión entre registro, login y home.
Inyectarlo en el punto de entrada evita pasar el mismo objeto por cada vista intermedia.
Al cambiar `currentUser`, el flujo raíz reacciona y muestra Home o Login.
Las vistas consumidoras declaran `@EnvironmentObject` explícitamente.
Las previews también deben inyectar un `SessionStore` para no fallar al ejecutarse.

## 4. Home: filtrado fuera del `body`
SwiftUI puede recalcular el `body` muchas veces por cambios de estado no relacionados.
Filtrar el catálogo completo allí repetiría trabajo y mezclaría presentación con lógica.
`HomeViewModel` combina `$items` y `$searchText` con Combine.
Un `debounce` de 250 ms reduce recomputaciones durante la escritura.
La vista lee `filteredItems`, ya publicado; la búsqueda no se calcula en el listado.

## 5. Detalle: modelo por valor
`ItemModel` es un `struct` inmutable, identificable y `Hashable` para `NavigationLink(value:)`.
El detalle recibe una instantánea del producto sin observar un objeto compartido mutable.
`@ObservedObject` requiere una clase observable y no aporta nada a estos datos fijos.
Si el detalle editara un producto compartido en tiempo real, convendría un modelo observable.
Alternativamente, un store compartido podría publicar cambios y localizar el producto por `id`.
