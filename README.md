# repositorios de apliciones

- iOS: https://github.com/LuisTapiaLml/ios_pickup.git

- Android: https://github.com/LuisTapiaLml/android_pikcup.git

---
se adjunta una coleccion de postman con los endpoint necesarios para consultar usuarios (get users)
en todos los casos la CONTRASEÑA es : 123456789


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

---


Las ordenes se pueden

- confirmar
- rechazar 
- entregar

hay productos que se les debe asignar un numero de serie,
estos productos estan marcados con una leyenda `numero de serie`
si esta leyenda es color rojo, signifa que aun no se le ha asignado numero de serie, si es color azul, significa que ya tienen uno.

Para asignar un numero de serie a un producto, dar click el item del producto, aparecera un modal con los inputs depediendo la cantidad de articulos que se compraron, y a cada uno se le debe asignar numero de serie

para fines practicos, el backend no valida este campo, asi que se puede escribir cualquier texto

una vez los todos los productos tengan numero de serie, la orden ya se puede confirmar y posterior mente entregar, ( esto unicamente cambiara el estatus de la orden ) 

si los productos no necesitan numero de serie, la orden se puede confirmar sin necesidad de hacer el paso anterior

