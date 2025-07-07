# repositorios de apliciones

- iOS: https://github.com/LuisTapiaLml/ios_pickup.git

- Android: https://github.com/LuisTapiaLml/android_pikcup.git

---
se adjunta una coleccion de postman con los endpoint necesarios para consultar usuarios (get users)
en todos los casos la CONTRASEÑA es : 123456789

- user1@gmail.com 
    - userid : 1
- user2@gmail.com 
    - userid : 2
- user3@gmail.com
    - userid : 3
- user4@gmail.com
    - userid : 4
- user5@gmail.com
    - userid : 5



---

para crear una nueva orden para un usuario de debera ocupar el endpoint `new order`
con el siguiente payload
es necesario hacer login primer con el request de `Login`

{
    "storeId" : {userid}
}

userid : id del usuario al que se le quiere asignar el pedido

para ver las nuevas ordenes en la aplicacion, se puede user el boton de recargar
para refrescar la lista de ordenes

![Ejemplo crear orden](https://res.cloudinary.com/dslnjpd7t/image/upload/v1751857130/pikcup/create_order.png)

---

Al iniciar sesion se mostrara un listado con las ordenes del respectivo usuario

se pueden filtar por estaus o por un campo de busqueda `Sensible a mayusculas y minusculas`, donde se puede buscar por nombre del cliente o numero de pedido

<p align="center">
  <img src="https://res.cloudinary.com/dslnjpd7t/image/upload/v1751857938/pikcup/Captura_de_pantalla_2025-07-06_a_la_s_9.11.58_p.m._ypqh0b.png" width="250" style="margin-right: 10px;" />
  <img src="https://res.cloudinary.com/dslnjpd7t/image/upload/v1751857892/pikcup/orders%20android.png" width="250" />
</p>

---


Las ordenes se pueden

- confirmar
- rechazar 
- entregar


hay productos que se les debe asignar un numero de serie,
estos productos estan marcados con una leyenda `numero de serie`
si esta leyenda es color rojo, signifa que aun no se le ha asignado numero de serie, si es color azul, significa que ya tienen uno.

<p align="center">
  <img src="https://res.cloudinary.com/dslnjpd7t/image/upload/v1751857314/pikcup/num_serie_ios.png" width="250" style="margin-right: 10px;" />
  <img src="https://res.cloudinary.com/dslnjpd7t/image/upload/v1751857386/pikcup/num_serie_android.png" width="250" />
</p>



Para asignar un numero de serie a un producto, dar click el item del producto, aparecera un modal con los inputs depediendo la cantidad de articulos que se compraron, y a cada uno se le debe asignar numero de serie

para fines practicos, el backend no valida este campo, asi que se puede escribir cualquier texto alfanumerico


<p align="center">
  <img src="https://res.cloudinary.com/dslnjpd7t/image/upload/v1751857597/pikcup/add%20num%20serie%20ios.png" width="250" style="margin-right: 10px;" />
  <img src="https://res.cloudinary.com/dslnjpd7t/image/upload/v1751857697/pikcup/add%20num%20serie%20android.png" width="250" />
</p>

Una vez los pedidos hayan sido confirmados, el numero de serie ya no se podrá modificar

---

Ya que  todos los productos tengan numero de serie, la orden ya se puede confirmar y posterior mente entregar, ( esto unicamente cambiara el estatus de la orden ) 

si los productos no necesitan numero de serie, la orden se puede confirmar sin necesidad de hacer el paso anterior

<p align="center">
  <img src="https://res.cloudinary.com/dslnjpd7t/image/upload/v1751858424/pikcup/Captura_de_pantalla_2025-07-06_a_la_s_9.19.35_p.m._yoxtj3.png" width="250" style="margin-right: 10px;" />
  <img src="https://res.cloudinary.com/dslnjpd7t/image/upload/v1751858354/pikcup/Captura_de_pantalla_2025-07-06_a_la_s_9.16.35_p.m._nh61fm.png" width="250" />
</p>


---

# Pickup    

La aplicacion de pickup esta pensada como una actualización de la aplicacion que actualmente ocupa la empresa, fue desarrollada en xamarin y presenta problemas de compatibilidad con los ides en ios y sobre todo problemas de funcionalidad. Por lo que se considera necesario una nueva version para evitar errores recurrentes dentro de la aplicacion 

El logo es sencillo, se quizo algo autodescriptivo por lo que es el mismo nombre de la aplicación (Pickup)

Debido a que los dispositivos en las tiendas son variados, se opto por una maxima compatibilidad, haciendo uso como minumimo del API 24 en android y iOS v16.6

Ya que en su mayoria las vistas son listas de items, se opto por fijar las vista en portrait para una mejor experiencia del usuario.

## Depencencias

### iOS
- Alamofire 


### iOS
- retrofit
- gson
- lifecycle.runtime.ktx
- splashscreen


