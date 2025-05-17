pipeline {
    agent any

    stages {
        // Stage 1: Checkout code from the correct branch
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'main']], // Replace 'main' with your branch (e.g., 'master')
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/Asikmusta/cursor.git']]
                ])
            }
        }

        // Stage 2: Build Docker image in OpenShift
       stage('Build') {
            steps {
                script {
                    openshift.withCluster() {
                        // Explicitly set namespace for all operations
                        openshift.withProject('cursor-app') {  
                            // Verify BuildConfig exists first
                            if (openshift.selector("bc", "cursor-app").exists()) {
                                openshift.startBuild("cursor-app", "--from-dir=.")
                            } else {
                                error "BuildConfig 'cursor-app' not found in namespace 'cursor-app'"
                            }
                        }
                    }
                }
            }
        }

        // Stage 3: Deploy to OpenShift
        stage('Deploy') {
            steps {
                script {
                    openshift.withCluster() {
                        openshift.withProject('cursor-app') {
                            // First check if the app exists
                            if (!openshift.selector("dc", "cursor-app").exists()) {
                                // Create all resources from the image stream
                                openshift.newApp("cursor-app:latest", "--name=cursor-app")
                                // Wait for deployment to be ready
                                openshift.selector("dc", "cursor-app").untilEach(1) {
                                    dc -> dc.object().status.availableReplicas > 0
                                }
                            } else {
                                // If exists, just trigger a new deployment
                                def dc = openshift.selector("dc", "cursor-app")
                                dc.rollout().latest()
                            }
                        }
                    }
                }
            }
        }

        // Stage 4: Expose Route (if not exists)
        stage('Expose Route') {
            steps {
                script {
                    openshift.withCluster() {
                        if (!openshift.selector("route", "cursor-app").exists()) {
                            openshift.expose("svc/cursor-app")
                        }
                    }
                }
            }
        }
    }
}
