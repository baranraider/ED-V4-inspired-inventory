Sadece old qbcore uyumludur.

Not : qb-weapons içerisinde ki tgian-hud:load-data adlı eventi qbcore içerisinde onPlayerLoaded içerisine yazmanız gerekiyor. Sunucuya ilk girdiğinizde mermilerinizi yüklemesi açısından.

qb-inventoryv2/server.lua içerisinde giveitem komutunun içerisinde silahlar için seri numarası verme kodu bulunmakta. Orada ki info.serie içerisinde ki değeri qb-core/server/players.lua içerisinde ki silah seri numarası koduyla aynı yapın.

Craft sisteminin kullanımı; -- ÜRET butonunda bir tablo hariç diğer hangi craft tablolarını da görebilmesini istiyorsanız aşağıda ki adımı uygulayın. -- Örnek olarak polis tablosuna sivil ve hacker eklemek istiyorsunuz. O zaman ise; Polis tablonun hemen altına ek = {"sivil"}, ekleyerek sivil tablosunu veya ek{"sivil","hacker"}, olarak iki tablo ekleyebilirsiniz.
İstediğiniz kadar job ve craft tablosu ekleyebilirsiniz.

Envanter hakkında fotoğraflar;


![image](https://github.com/baranraider/ED-V4-inspired-inventory/assets/73917011/1c305912-3ad0-42b0-9598-1a2bb4e5b56e)

![image](https://github.com/baranraider/ED-V4-inspired-inventory/assets/73917011/b5e8d629-9c9a-4c58-a991-14b570cd51ab)

![image](https://github.com/baranraider/ED-V4-inspired-inventory/assets/73917011/7b0ae300-7b6d-4f30-b32e-ab258826507f)



