// When the content is fully loaded, run the event "getVisitCount()"
window.addEventListener("DOMContentLoaded", () => {
    getVisitCount();
});

// URL for the Function API
const functionApiUrl = "";

// Local Function API URL (if applicable)
const localFunctionApiUrl = "";

// Function to get the visit count
const getVisitCount = () => {
    let count = 30; // Default visit count

    // Fetch the count from the Function API URL
    fetch(functionApiUrl)
        .then(response => response.json()) // Parse the JSON response
        .then(data => {
            console.log("Website called function API."); // Log a message to the console
            count = data.count; // Update the count with the API response
            document.getElementById("counter").innerText = count; // Update the counter in the HTML
        })
        .catch(error => {
            console.error("Error fetching visit count:", error); // Log any errors to the console
        });

    return count; // Return the count
};