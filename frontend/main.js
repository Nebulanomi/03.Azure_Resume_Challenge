///Call function getVisitCount
window.addEventListener('DOMContentLoaded', (event) => {
    getVisitCount();
})

//const = The variable will be the same value forever
const functionApi = 'http://localhost:7071/api/Get_Resume_Counter';

const getVisitCount = () => {
    //let = The variable will change
    let count = 30;
    fetch(functionApi).then(response => {
        return response.json()
        }).then(response =>{
        console.log('Website called function API.');
        count = response.count;
        document.getElementById('counter').innerText = count;
        }).catch(function(error){
            console.log(error);
        });
        return count;
    }