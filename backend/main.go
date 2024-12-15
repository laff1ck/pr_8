package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"strings"
)


type Item struct {
	ID          int    `json:"ID"`
	Name        string `json:"Name"`
	Description string `json:"Description"`
	ImageLink   string `json:"ImageLink"`
	Price       int    `json:"Price"`
}



var items = []Item{
	{ID: 1, Name: "aghanim's Shard", Description: "With origins known only to a single wizard, fragments of this impossible crystal are nearly as coveted as the renowned scepter itself.", ImageLink: "https://liquipedia.net/commons/images/7/79/Aghanim%27s_Shard_itemicon_dota2_gameasset.png", Price: 1400},
	{ID: 2, Name: "Blink Dagger", Description: "The fabled dagger used by the fastest assassin ever to walk the lands.", ImageLink: "https://liquipedia.net/commons/images/d/dc/Blink_Dagger_itemicon_dota2_gameasset.png", Price: 2250},
	{ID: 3, Name: "Demon Edge", Description: "One of the oldest weapons forged by the Demon-Smith Abzidian, it killed its maker when he tested its edge.", ImageLink: "https://liquipedia.net/commons/images/4/44/Demon_Edge_itemicon_dota2_gameasset.png", Price: 2200},
	{ID: 4, Name: "Hand of Midas", Description: "Preserved through unknown magical means, the Hand of Midas is a weapon of greed, sacrificing animals to line the owner's pockets.", ImageLink: "https://liquipedia.net/commons/images/6/69/Hand_of_Midas_itemicon_dota2_gameasset.png", Price: 2200},
	{ID: 5, Name: "Boots of Bearing", Description: "Resplendent footwear fashioned for the ancient herald that first dared spread the glory of Stonehall beyond the original borders of its nascent claim.", ImageLink: "https://liquipedia.net/commons/images/2/2f/Boots_of_Bearing_itemicon_dota2_gameasset.png", Price: 4275},
	{ID: 6, Name: "Aghanim's Blessing", Description: "The scepter of a wizard with demigod-like powers.", ImageLink: "https://liquipedia.net/commons/images/1/1b/Aghanim%27s_Scepter_itemicon_dota2_gameasset.png", Price: 5800},
}


func enableCors(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Access-Control-Allow-Origin", "*")
        w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
        if r.Method == http.MethodOptions {
            return
        }
        next.ServeHTTP(w, r)
    })
}


func getItemsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(items)
}


func createItemHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	var newItem Item
	err := json.NewDecoder(r.Body).Decode(&newItem)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	newItem.ID = len(items) + 1
	items = append(items, newItem)

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(newItem)
}


func getItemByIDHandler(w http.ResponseWriter, r *http.Request) {
	idStr := strings.TrimPrefix(r.URL.Path, "/items/")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid Item ID", http.StatusBadRequest)
		return
	}

	for _, item := range items {
		if item.ID == id {
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(item)
			return
		}
	}

	http.Error(w, "Item not found", http.StatusNotFound)
}


func deleteItemHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodDelete {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	idStr := strings.TrimPrefix(r.URL.Path, "/items/delete/")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid Item ID", http.StatusBadRequest)
		return
	}

	for i, item := range items {
		if item.ID == id {
			items = append(items[:i], items[i+1:]...)
			w.WriteHeader(http.StatusNoContent)
			return
		}
	}

	http.Error(w, "Item not found", http.StatusNotFound)
}


func updateItemHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPut {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	idStr := strings.TrimPrefix(r.URL.Path, "/items/update/")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid Item ID", http.StatusBadRequest)
		return
	}

	var updatedItem Item
	err = json.NewDecoder(r.Body).Decode(&updatedItem)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	for i, item := range items {
		if item.ID == id {
			items[i] = updatedItem
			items[i].ID = id

			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(items[i])
			return
		}
	}

	http.Error(w, "Item not found", http.StatusNotFound)
}

func main() {
	http.HandleFunc("/items", getItemsHandler)             // Получить все предметы
	http.HandleFunc("/items/create", createItemHandler)    // Создать предмет
	http.HandleFunc("/items/", getItemByIDHandler)         // Получить предмет по ID
	http.HandleFunc("/items/update/", updateItemHandler)   // Обновить предмет
	http.HandleFunc("/items/delete/", deleteItemHandler)   // Удалить предмет

	fmt.Println("Server is running on port 8080!")
	http.ListenAndServe(":8080", nil)
}
