# Shipping Adm
**— an application to manage shipping providers for an e-commerce**

:warning:  Project status: ongoing   

### Features
- [x] Users and admins can log in  
- [x] Admin can register, view, edit and delete a Shipping Company  
- [x] User can edit some info about their own company  
- [ ] Shipping Company users can load their company's prices and delays
- [x] Admin can request quotes and choose a shipping company for a certain delivery
- [x] Shipping Company users can accept or reject service orders
- [ ] Shipping Company users can create, edit and destroy their logistic outposts
- [x] Shipping Company users can create shipment updates for a certain package
- [x] Guest users can track a shipment with only a tracking code

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
  
To stop the application, go back to the window where you started the application and press `control + C` (or `^ + C` for Mac users).  

### Demo

If you want to see the application running with some mock data, go to the project directory and run  
`$ bin/rails db:seed`  
  
This will acivate the following credentials:   
- admin: admin@email.com, password: 123456  
- user :  user@email.com, password: 123456  
  
And also creates some packages already in process of delivery, such as: http://localhost:3000/deliveries/HU876592369BR  
  
If you want to clean the mock data, you can go to the project directory and run  
`$ bin/rails db:reset`  
(please note this delete all data, not only the demo items)  

### Test suit

On the project directory, run   
`$ bin/bundle exec rspec`   
  
### Other info
App developed in the context of the [Treinadev](https://treinadev.com.br/) bootcamp
