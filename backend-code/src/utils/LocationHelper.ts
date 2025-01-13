import axios from "axios";

interface Coordinates {
  lat: number;
  lng: number;
}

export async function getCoordinates(
  address: string
): Promise<Coordinates | null> {
  const API_KEY = process.env.GOOGLE_MAPS_API;

  if (!API_KEY) {
    throw new Error(
      "Google Maps API key is not defined in environment variables."
    );
  }
  try {
    const response = await axios.get(
      "https://maps.googleapis.com/maps/api/geocode/json",
      {
        params: {
          address: address,
          key: API_KEY,
        },
      }
    );

    if (response.data.status === "OK") {
      const location = response.data.results[0].geometry.location;
      console.log(`Latitude: ${location.lat}, Longitude: ${location.lng}`);
      return location;
    } else {
      console.error(`Error: ${response.data.status}`);
      return null;
    }
  } catch (error) {
    console.error("Error fetching data:", error);
    return null;
  }
}
