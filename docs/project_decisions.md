# Project decisions

## Rates
This original instructions for this project assumed shipping companies would provide a single table which considered both distances and weight to define a shipping rate, like
|Cubic meters/Weight|0-10kg|10-30kg|over 30kg|
---|---|---|---|
|0,001 a 0,500|50 cents per km|80 cents per km| 100 cents per km
|0,001 a 0,500|75 cents per km|105 cents per km| 125 cents per km
|0,001 a 0,500|100 cents per km|130 cents per km| ...
|0,501 a 1,000|75 cents per km|...| ...

Such a data structure was difficult to model. Furthermore, research has indicated that shipping companies often use the concept of *cubic weight*, which calculates a "virtual weight" based on the size of the package. Since this approach was both easier to model and had a strong correlation to actual business, this was the choice of implementation.

### Example of fee calculation
factor for calculation of cubic weight, FCW = 300 kg/m³   
minimal fee = 10.000 cents  
weight|rate
---|---|
|up to 1kg|50 cents per km|
|1 - 5kg|75 cents per km|
|5 - 10kg|100 cents per km|
|10 - 30kg|125 cents per km|

Package size: 40 x 20 x 15 cm | 2 kg | 8 km  
  
dead weight = real weight = 2 kg  
cubic weight = product of measures * FCW = (40/100 * 20/100 * 15/100) * 300 = 5,4 kg  
  
Weight to be considered: the biggest between dead weight (2 kg) and cubic weight (5,4 kg) - that is, 5,4 kg. Therefore the rate is 100 cents per km.  
  
Fee = 100 cents per km * 8 km = 8.000 cents. However, this is lower than the company's minimal fee, so the fee for this package is the company's minimal fee of 10.000 cents.
  
## Outposts, not vehicles

The original instructions for this project required the shipping companies to be able to register their vehicles; and separetely, it required a page showing all updates of the trajectory of a package. Presumably then, the delivery history would be compounded of vehicles' movements.

The author of this app tought this was too far removed from reality: while vehicles do transport packages, there isn't really a tie between vehicles and packages - if a truck is broken the morning of a delivery, the company will just send another truck to do the job, and this is irrelevant to the process of delivery. What *is* relevant is the location of the package, but sharing the positioning of a vehicle for the purpose of package tracking is neither practical nor safe.

Therefore, this app does not support vehicles. It uses instead the passage of a package through logistical outposts as the compounder of a delivery history. 