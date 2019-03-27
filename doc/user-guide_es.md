# Wor-Prof

Wor-prof (Wprof) es una gema para Ruby On Rails cuyo único objetivo es el medir el rendimiento de una aplicación RoR mediante un perfil de distintos tiempos de respuesta. Para lograrlo, Wprof utiliza ActiveSupport::Notifications (disponible en Rails desde la versión 4.0.2) para capturar toda acción de sus controladores. Pero no sólo eso, si usas httparty en tu proyecto también puedes capturar cada request realizada a servicios externos. Tienes uno o más métodos que también quisieras conocer cuánto se demoran en ejecutarse? Con Wprof puedes saberlo. Luego, cada dato obtenido puede reportarse de distintas formas, elige una entre el logger de Rails, base de datos, archivo de texto en formato CSV o bien realiza un request Post a donde quieras… hazlo de forma sincrónica o asíncrona.

---

## Comenzar.

El primer paso es instalar la gema (por supuesto) y la forma es bien conocida, pero por si acaso acá están los pasos a seguir.

### Installation
Agregar la siguiente línea en el gemfile de tu aplicación Rails:

```ruby
gem 'wor-prof'
```

Y luego ejecute:
```bash
$ bundle install
```
**Eso es todo!!** Al correr el servidor Wprof comienza inmediatamente a trabajar con la configuración por defecto por lo que no hay que configurar nada si coincide con sus necesidades, pero si no es así puede consultar la sección de **Configuraciones Disponibles**.

---

## Tipos de registros y cómo funciona.

Como tipo de registros WProf cuenta con los siguientes.

* Controladores: Cada request realizada a Rails que es manejada por un *Controller*. (Esto viene por defecto y no puede desactivarse)
* HTTParty: Cada vez que se invoca un método de HTTParty.
* Métodos propios: Se puede definir un Array de Métodos a capturar.

``Solamente "Controladores" son automáticamente perfilados con sólo agregar la gema, el resto necesita alguna configuración u operación extra.``

### HTTparty
HTTParty es una popular herramienta para Ruby que permite realizar fácilmente peticiones HTTP. Si no está familiarizado con la gema le recomiendo leer más sobre está en el repositorio de la misma, [aquí!](https://github.com/jnunemaker/httparty)

Para poder perfilar las request que se hacen mediante HTTParty debe incluir Wprof justo después de Httparty. Es decir:
```ruby
class FooClass
    include HTTParty
    include Wprof
```
Qué significa esto? Wprof envuelve los métodos invocados como métodos de clase, espera la respuesta y captura algunos datos necesarios para generar el perfil. Es por esto que la inclusión del módulo debe ser **obligatoriamente** después de HTTParty... si esto no es así, sencillamente no funcionará.

Por defecto, WProf define los métodos que comúnmente se utilizan para generar una petición (Get, Put, Delete, Post), sin embargo puede definir otros o bien quitar alguno de esos de la lista. Es **fuertemente recomendado** no **agregar** métodos de HTTParty sin estar completamente seguro que el retorno de estos coincide con lo que WProf buscará capturar (puede consultar la sección "Datos Capturados" para conocer cuales son).

### Métodos propios

Algunas veces puede resultar de utilidad conocer cuánto se demora un método específico en ejecutarse, para este fin Wor-prof puede extender una mano.

Para lograrlo se necesitan seguir 2 pasos.

1. Preparar un array de métodos que se desean trazar (consulte la sección de configuración: "custom_methods")
2. Incluir Wprof a la clase que tiene dicho método.

Listo, con esto Wprof estará registrando el tiempo de ejecución de dicho método cada vez que sea invocado y lo reportará.

---

## Configuraciones disponibles.

Por defecto Wprof continúe una lista de configuraciones por defecto, pero todas estas pueden ser modificadas por otras disponibles de acuerdo a las preferencias del usuario. Para lograr esto se debe crear un archivo en 'config/initializers' (RailsApp.Root >> config >> initializers >> wprof.rb).
Dentro del mismo se debe definir la configuración de esta manera: 

```ruby
Rails.application.configure do
  config.x.wprof.db_runtime = true
  config.x.wprof.reporter_type = 'FILE'
end
```
> En caso de no configurar correctamente una opción u omitirla, se tomarán los valores por defecto.

Para evitar esta configuración manualmente utilizando el **Generador de Configuración** con el comando "rails generate wprof" (consulte la sección de generadores).

A continuación se ofrece la lista completa de configuraciones disponibles y sus significados.

### config.x.wprof.db_runtime
Define si se debe mostrar o no el dato "db_runtime" dentro del reporte.
> Valores Posibles: true o false
> Por defecto: true

### config.x.wprof.reporter_type 
Establece el tipo de reporte, es decir, como exponen los datos obtenidos, existen cuatro tipo disponible actualmente, Ver sección "Reportes" para más información.
> Valores Posibles: LOGGER, FILE, DATABASE, EXTERNAL
> Por defecto: LOGGER

### config.x.wprof.csv_type
Cuando se define el reporte como un archivo CSV existen dos formas de generarlos.
* **MIX:** Genera un único archivo CSV donde se guardan los datos de **todo** lo que captura WProf. Este archivo solo tiene 2 columnas: En la primera se guarda el campo y en la segunda el dato.
* **SPLIT:** Divide el almacenamiento en tres archivos distintos, uno por cada tipo de registro. Esto mejora significamente la lectura ya que cada campo está como encabezado del archivo y los datos en la filas separados por coma... como debe ser claro... ¿Por que mix entonces?, no sé, a alguno le puede servir!
> Valores Posibles: MIX, SPLIT
> Por defecto: SPLIT

### config.x.wprof.async
Define si el reporte se gestará de forma Sincrónica o Asincronica. **Tome nota: la forma asincrónica requiere pasos adicionales, consulte la sección de "Asincronismo" para más información**
> Valores Posibles: false, true
> Por defecto: false

### config.x.wprof.httparty_methods_to_trace
Métodos de HTTParty que WProf va a capturar. Por defecto se colocan los más comunes y se recomienda no modificar. Dicho esto, no hay problema en quitar algunos del array, pero tenga especial cuidado en agregar métodos de HTTParty que no devuelvan un request HTTP).
> Valores Posibles: Los que quiera, debe si o si ser un **Array** de strings.
> Por defecto: ['get', 'put', 'delete', 'post']

### config.x.wprof.external_url
En caso de que se configure el reporter_type como External, se debe indicar la URL a la que se enviará la petición HTTP.
> Valores posibles: Cualquier cadena de texto que corresponda a una URL. Ejemplo: 'http://example-url/reporter'
> Por defecto: nil

### config.x.wprof.external_headers
Para agregar una cabecera al request HTTP (para el tipo de reporte "External"), debe definirlo en esta configuración. La misma debe ser un **HASH de RUBY** tal cual como espera HTTParty recibir (internamente Wprof utiliza HTTParty para enviar el request). Un ejemplo de esto sería:
``` ruby
config.x.wprof.external_headers = { headers: {'User-Agent' => 'Httparty'}}
```
> Valores posibles: Cualquier hash válido, debe respetarse la primera clave como "headers" (ver ejemplo arriba)
> Por defecto: nil

### config.x.wprof.custom_methods
Si desea capturar los tiempos de respuesta de un método específico dentro de una clase, no basta con incluir el módulo, debe indicarle a Wprof cual es exactamente aquel que desea capturar. Esta lista de métodos debe estar contenida en está opción dentro de un **Array de Ruby** y deben ser strings. Ejemplo:
``` ruby
config.x.wprof.custom_methods = [ 'my_great_method' ]
```
> Valores posibles: Cualquier nombre de método en formato string, contenido en un array.
> Por defecto: nil

### config.x.wprof.file_path

Cuando se utiliza "FILE" como salida de datos, esta opción permite elegir la ruta de destino de los archivos. Esta debe ser una ruta válida, en formato string, con permisos de escritura para la aplicación Rails y cuyo último valor debe ser una carpeta. Ejemplo: 
``` ruby
config.x.wprof.file_path = '/home/mcolombo/examplefolder'
```
> Valores posible: Cualquier string que represente correctamente un PATH hasta un directorio.
> Por defecto: Se utiliza 'Rails.root', es decir, la raíz de su aplicación Rails.

---

## Generadores.

WProf tiene disponible dos [generadores de Rails](https://guides.rubyonrails.org/command_line.html#rails-generate) disponibles.

---

### Generador del archivo de Configuración.

Para comenzar a modificar las opciones de configuración disponibles, debe crear un archivo de configuración dentro de los 'config/initializers' (como se mencionó en la sección "Configuraciones disponibles"). A favor de evitar pasos innecesarios y posibles equivocaciones en los peligrosos 'copy/paste', puede generar este archivo como un template con el siguiente comando Rails:

```
rails generate wprof
```
Esto  generará un modelo del archivo de configuración, con todas las opciones disponibles vistas en la sección "Configuraciones disponibles".

### Generador del modelo de datos

Una opción disponible para reportar la información capturada es la misma Base de Datos que utiliza Rails, pero el problema de esto es que se requiere justamente definir el modelo. Este generador creará todos los archivos de migración y los modelos para poder utilizar esta opción sin preocuparse por nada más.
```
rails generate wprof_model
```
Esto generará los archivos de migración y los modelos (incluso los controladores por si desea manejarlos!)
**Recuerde que para que los modelos se encuentren disponibles en la base aún debe correr la migración**
```
rails db:migrate
```

---

## Datos capturados.

Los datos que captura y reporta WProf varían de acuerdo a que tipo de registro proviene, sin embargo, todos comparten algunos datos base.

### Datos base (comunes para todos)

* **transaction_id:** identificador único de cada transacción. Este campo es de vital importancia debido a que los registros de HTTParty y Métodos comparten este mismo identificador con el Request que disparó esta ejecución permitiendo una traza completa de la ejecución de cada uno.
* **total_time:** Tiempo total de ejecución registrado (en milisegundos).
* **start_dt:** Campo de Fecha y Hora en que comenzó a registrarse.
* **end_dt:** Campo de Fecha y Hora en que finalizó el registro.

### Únicos para el Controlador.

* **code:** Código de respuesta enviado por el controlador (Status), ej. 200, 404, etc.
* **controller:** Controlador que manejó el request.
* **url:** endpoint que recibió la solicitud.
* **db_runtime:** Tiempo total que fue absorbido por la Base de Datos (incluido en el total_time).

### Únicos para los Servicios (Httparty).

* **code:** Código de respuesta recibido (Status), ej. 200, 404, etc.
* **service_hostname:** Hostname del servicio consumido.
* **request_uri:** Uri del endpoint consumido.

### Únicos para los métodos.

* **method:** Nombre del método que fue medido.

---

## Reportes.

El destino de los datos, una vez que son capturados y procesados, varía de acuerdo a las preferencias del usuario. Wor-Prof ofrece los siguientes destinos para la información:
* **LOGGER:** Utiliza Rails.logger para mostrar la información.
* **FILE:** Guarda la información en uno ó varios archivos de texto separados por coma (csv)
* **DATABASE:** Almacena los datos obtenidos en la misma base de datos que utiliza la aplicación Rails (requiere preparar el modelo, ver generadores/generador del modelo de datos)
* **EXTERNAL:** Realiza una petición POST con los datos enviados en el cuerpo en formato JSON. (requiere configuración adicional)

> Tanto "Logger" como "File" no necesitan configuración adicional para trabajar, sin embargo "Database" y "External" requieren pasos previos.

### Database Reporter

Para **DATABASE** es necesario generar un esquema que permita almacenar la información. Para lograr esto ponemos a disposición un generador, sin embargo, si se desea generar manualmente WProf necesita los siguientes modelos (se exponen los archivos de Migración).

> Modelo: WprofController
``` ruby
class CreateWprofControllers < ActiveRecord::Migration[5.0]
  def change
    create_table :wprof_controllers do |t|
      t.string :transaction_id
      t.float :total_time
      t.datetime :start_dt
      t.datetime :end_dt
      t.integer :code
      t.string :controller
      t.string :url
      t.float :db_runtime

      t.timestamps
    end
    add_index :wprof_controllers, :transaction_id
    add_index :wprof_controllers, :code
    add_index :wprof_controllers, :url
  end
end
```
> Modelo: WprofService
``` ruby
class CreateWprofServices < ActiveRecord::Migration[5.0]
  def change
    create_table :wprof_services do |t|
      t.string :transaction_id
      t.float :total_time
      t.datetime :start_dt
      t.datetime :end_dt
      t.integer :code
      t.string :service_hostname
      t.string :request_uri

      t.timestamps
    end
    add_index :wprof_services, :transaction_id
    add_index :wprof_services, :code
    add_index :wprof_services, :service_hostname
    add_index :wprof_services, :request_uri
  end
end
```
> Modelo: WprofMethod
``` ruby
class CreateWprofMethods < ActiveRecord::Migration[5.0]
  def change
    create_table :wprof_methods do |t|
      t.string :transaction_id
      t.float :total_time
      t.datetime :start_dt
      t.datetime :end_dt
      t.string :method

      t.timestamps
    end
    add_index :wprof_methods, :transaction_id
    add_index :wprof_methods, :method
  end
end
```

### External Request Reporter.
Una opción es enviar los datos por HTTP donde desee. Los datos obtenidos por Wprof serán enviados en el cuerpo como un JSON. Para que esto funcione bien es **necesario configurar la URL de destino**. La petición que se genera es POST y de ser necesario puede **configurar los HEADERS necesarios**. Si la URL no se configura, la petición no será enviada.

Las opciones a configurar son: external_url y external_headers. Consulte la sección de Configuraciones para más información.

---

## Asincronismo.

WProf por defecto reporta toda la información de manera ***sincronica**, sin embargo es posible configurar la herramienta para que este proceso lo haga de forma **asincronica**. Para lograr esto se debe en primer lugar activar la opción mediante la configuración del campo "config.x.wprof.async = true", sin embargo esto no es suficiente.
Para que todo el reporte se efectúe Asincrónicamente, es necesario tener funcional y operativo **Sidekiq**, ya que WProf lo utiliza para tal fin. Si no está familiarizado con la herramienta, puede buscar más información en el [repositorio de la misma haciendo click aquí!](https://github.com/mperham/sidekiq).

---

## Errores manejados.

Cualquier error dentro del proceso de captura y reporte de la información **NO DEBERIA** interrumpir el normal funcionamiento de su aplicación Rails. Si esto es así, por favor **reportelo**.
Durante la ejecución, podrían aparecer dos errores en el Logger de la aplicación.

```WProf ERROR when try parsing service response:``` Este error puede mostrarse si no fue posible capturar algún dato por parte de HTTParty.

```An error was raised when WProf tried to send data to reporter:``` Este es el error más típico y se mostrará en caso de que el envío de datos al destino seleccionado (es decir Logger, Database, File o External) haya fallado.

---