# Shipping Adm
**— an application to manage shipping providers for an e-commerce**

:warning:  Project status: ongoing   

### Entities

This app intends to help manage the relationship between an e-commerce and its many shipping providers.

A **Shipping Company** is one such provider. It can be *in registration*, *suspended* or *active*. Only active companies participate in the quoting process, and for this they are required to provide their tables of **Shipping Rate**s and **Delivery Time**s, as well as a factor for calculation of cubic weight and their minimal fee.

**User** is the model managing access to the application. The role of *admin* is designed for an employee of the e-commerce who obtains quotes and distributes service orders, whereas the role of *user* is designed for an employee of a shipping company who accepts or rejects orders on its behalf, and who provides updates for ongoing deliveries.

A **Package** is the information this app receives from another part of the e-commerce system. It is immediately tied to an **Service Order** after reception.

The **Service Order** is the main object of the app. Its status tracks its life: it starts as *unassigned*, changes to *pending* when a shipping company is offered the shipping service, and then changes to *accepted* or *rejected* according to the shipping company response. Its end-of-life options are *canceled*, or, more happily, *delivered*. 

To help admins on their task to choose a shipping company, they can run a **Quote**, which will retrieve prices and delivery times from all active companies for a given package. Each set of quotes is recorded and can be audited anytime.

When a shipping company accepts a service order, a **Delivery** is created, which records the **Stage**s of delivery, that is, the route of a package through the many **Outpost**s of a shipping company. This information can be accessed with a link by an unlogged person, and is intended to allow the costumers of the e-commerce to track their buys.

### Features

- [x] Users and admins can log in  
- [x] Admin can register, view, edit and delete a Shipping Company  
- [x] User can edit select data about their own company  
- [ ] Shipping Company users can load their company's prices and delivery times
- [x] Admin can request quotes and choose a shipping company for a certain delivery
- [x] Shipping Company users can accept or reject service orders
- [ ] Shipping Company users can create, view and delete their logistic outposts
- [x] Shipping Company users can create delivery updates for a certain package
- [x] Guest users can track a deliver with a link

### Installation

![This app requires Ruby 3.1.1 to be installed](https://img.shields.io/static/v1?label=ruby&message=version%203.1.1&color=B61D1D&style=for-the-badge&logo=ruby)

1 - Clone the repository  
`$ git clone git@github.com:kyriri/treinadev8-2shipping.git`

2 - Change to the project directory   
`$ cd treinadev8-2shipping`

3 - Install the gems / dependencies   
`$ bin/setup`

### Running the application

To start the application, on the project directory run:  
`$ bin/rails server`  
The app will become available at the web address http://localhost:3000/ and can be accessed from any browser.  
  
To stop the application, go back to the window where the application was started and press `control + C` (or `^ + C` on Mac's).  

### Demo

To see the application running with some mock data, go to the project directory and run  
`$ bin/rails db:seed`  
  
This will acivate the following credentials:   
- admin: admin@email.com, password: 123456  
- user :  user@email.com, password: 123456  
  
and will also create some packages already in process of delivery, such as: http://localhost:3000/deliveries/HU876592369BR  
  
To clean the mock data, go to the project directory and run  
`$ bin/rails db:reset`  
(please note this delete all data, not only the demo items)  

### Test suit

On the project directory, run   
`$ bin/bundle exec rspec`   
  
### Project decisions

#### Rates
This original instructions for this project assumed shipping companies would provide a single table which considered both distances and weight to define a shipping rate, like
|Cubic meters/Weight|0-10kg|10-30kg|over 30kg|
---|---|---|---|
|0,001 a 0,500|50 cents per km|80 cents per km| 100 cents per km
|0,001 a 0,500|75 cents per km|105 cents per km| 125 cents per km
|0,001 a 0,500|100 cents per km|130 cents per km| ...
|0,501 a 1,000|75 cents per km|...| ...

Such a data structure was difficult to model. Furthermore, research has indicated that shipping companies often use the concept of *cubic weight*, which calculates a "virtual weight" based on the size of the package. Since this approach was both easier to model and had a strong correlation to actual business, this was the choice of implementation.

**Example of fee calculation**
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
  
#### Outposts, not vehicles

The original instructions for this project required the shipping companies to be able to register their vehicles; and separetely, it required a page showing all updates of the trajectory of a package. Presumably then, the delivery history would be compounded of vehicles' movements.

The author of this app tought this was too far removed from reality: while vehicles do transport packages, there isn't really a tie between vehicles and packages - if a truck is broken the morning of a delivery, the company will just send another truck to do the job, and this is irrelevant to the process of delivery. What *is* relevant is the location of the package, but sharing the positioning of a vehicle for the purpose of package tracking is neither practical nor safe.

Therefore, this app does not support vehicles. It uses instead the passage of a package through logistical outposts as the compounder of a delivery history. 
  
### Other info

App developed in the context of the [Treinadev](https://treinadev.com.br/) bootcamp
