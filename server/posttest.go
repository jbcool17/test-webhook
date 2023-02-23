package server

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"

	v1 "k8s.io/api/core/v1"
)

func parsePod(object []byte) (*v1.Pod, error) {
	var pod v1.Pod
	if err := json.Unmarshal(object, &pod); err != nil {
		return nil, err
	}

	return &pod, nil
}

func GetFilenameDate() string {
	// Use layout string for time format.
	const layout = "01-02-2006-15:4:5.0"
	// Place now in the string.
	t := time.Now()
	return "admissionreview-" + t.Format(layout) + ".txt"
}

func postTest(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Write([]byte("POST TEST.\n"))

	log.Printf("POST TEST %v", r)
	var bodyBytes []byte
	var err error

	if r.Body != nil {
		bodyBytes, err = ioutil.ReadAll(r.Body)
		if err != nil {
			log.Printf("Body reading error: %v", err)
			return
		}
		defer r.Body.Close()
	}

	if len(bodyBytes) > 0 {
		var prettyJSON bytes.Buffer
		if err = json.Indent(&prettyJSON, bodyBytes, "", "\t"); err != nil {
			log.Printf("JSON parse error: %v", err)
			return
		}

		// OUTPUT JSON TO SCREEN
		log.Printf(string(prettyJSON.Bytes()))

		// Parse AdmissionReview
		var result AdmissionReview
		json.Unmarshal([]byte(bodyBytes), &result)
		log.Printf("result: %v", result)
		log.Printf("kind: %v - %v", result.Kind, result.APIVersion)
		log.Printf("NAMESPACE: %v", result.Request.Namespace)

		// GET POD OBJECT
		pod, err := parsePod(result.Request.Object.Raw)
		if err != nil {
			log.Printf("parsePod Error: %v", err)
			return
		}

		log.Printf("PARSED POD: %v", pod)

		// WRITE FILE TO TMP
		fileName := GetFilenameDate()
		err = os.WriteFile("/tmp/"+pod.ObjectMeta.GenerateName+"-"+fileName, bodyBytes, 0644)
		if err != nil {
			log.Printf("file write Error: %v", err)
			return
		}

	} else {
		log.Printf("Body: No Body Supplied\n")
	}

	log.Println("End of POST")
}
