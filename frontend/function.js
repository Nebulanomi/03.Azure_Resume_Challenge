// When content is loaded, run the event
window.addEventListener("DOMContentLoaded", (event) => {
    getvisitcount();
})

const functionapiurl = "https://getresumecounterlearn.azurewebsites.net/api/Get_Resume_Counter?code=85fxPLzl-43iZNRr8ff3mnk53pPA-ojY2YNAAUIo_qX-AzFuDyoj8g==";
const localfunctionapi = "http://localhost:7071/api/Get_Resume_Counter";

const getvisitcount = () => {
    
    let count = 30;
    
    fetch(functionapiurl).then(response => {
        return response.json()
    }).then(response => {
        console.log("Website called function API.");
        count = response.count;
        document.getElementById("counter").innerText = count;
        }).catch(function(error) {
            console.log(error);
        });
        
        return count;
    }