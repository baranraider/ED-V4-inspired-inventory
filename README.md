Sadece old qbcore uyumludur.

Not : qb-weapons içerisinde ki tgian-hud:load-data adlı eventi qbcore içerisinde onPlayerLoaded içerisine yazmanız gerekiyor. Sunucuya ilk girdiğinizde mermilerinizi yüklemesi açısından.

qb-inventoryv2/server.lua içerisinde giveitem komutunun içerisinde silahlar için seri numarası verme kodu bulunmakta. Orada ki info.serie içerisinde ki değeri qb-core/server/players.lua içerisinde ki silah seri numarası koduyla aynı yapın.

Craft sisteminin kullanımı; -- ÜRET butonunda bir tablo hariç diğer hangi craft tablolarını da görebilmesini istiyorsanız aşağıda ki adımı uygulayın. -- Örnek olarak polis tablosuna sivil ve hacker eklemek istiyorsunuz. O zaman ise; Polis tablonun hemen altına ek = {"sivil"}, ekleyerek sivil tablosunu veya ek{"sivil","hacker"}, olarak iki tablo ekleyebilirsiniz.
İstediğiniz kadar job ve craft tablosu ekleyebilirsiniz.

Envanter hakkında fotoğraflar;



![image](https://github.com/baranraider/ED-V4-inspired-inventory/assets/73917011/b5c9195c-c048-4804-a71c-13eeaca8ba65)
![image](https://github.com/baranraider/ED-V4-inspired-inventory/assets/73917011/1668e224-195b-4c1b-a5fe-f92370f526cb)
![image](https://github.com/baranraider/ED-V4-inspired-inventory/assets/73917011/f6434c88-b6be-49af-b36d-617055e7a291)

