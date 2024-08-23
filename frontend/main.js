// This event listener waits for the entire HTML document to be fully loaded and parsed before running the getVisitCount function.
window.addEventListener('DOMContentLoaded', (event) => {
    getVisitCount(); // Calls the function to get the visit count when the page is loaded.
});

// URL of the Azure Function API endpoint to get the visit count from the live server.
const functionApiUrl = 'https://getresumecounter.azurewebsites.net/api/GetResumeCounter?code=Q/LkPt0mhQKdP8DoE3DdllAYdFQO//58Iq7AoS6JUBj9FgJ86Rqt8A==';

// URL of the local Azure Function API endpoint to get the visit count when running locally.
const localFunctionApi = 'http://localhost:7071/api/Get_Resume_Counter';

// This is the URL that will be used to call the API. Currently, it is set to the local API URL for development purposes.
// You can switch between 'functionApiUrl' and 'localFunctionApi' depending on whether you're in production or development.
const apiUrl = localFunctionApi;

// This function is responsible for fetching the visit count from the API and updating the HTML element with the ID "counter" with the count.
const getVisitCount = () => {
    let count = 0; // Initialize the visit count to 0 in case the API call fails or takes time to respond.

    // Fetch the visit count from the API.
    fetch(apiUrl)
        .then(response => response.json()) // Parse the JSON response from the API.
        .then(data => { // Once the data is parsed, execute this block.
            console.log("Website called function API."); // Log a message indicating the API was called successfully.
            count = data.count; // Update the count with the value received from the API.
            document.getElementById("counter").innerText = count; // Update the HTML element with the ID "counter" to display the visit count.
        })
        .catch(error => { // If there's an error during the fetch, execute this block.
            console.error("Error fetching the visit count:", error); // Log the error to the console.
            document.getElementById("counter").innerText = "Error fetching count"; // Display an error message to the user.
        });

    return count; // Return the count, though this value is likely not used because the API call is asynchronous.
};