pipeline {
    agent any

    stages {
        // Stage 1: Build the Docker image using OpenShift
        stage('Build Docker Image') {
            steps {
                script {
                    openshift.withCluster() {
                        openshift.startBuild("cursor-app", "--from-dir=.")
                    }
                }
            }
        }

        // Stage 2: Deploy to OpenShift
        stage('Deploy to OpenShift') {
            steps {
                script {
                    openshift.withCluster() {
                        // Create DeploymentConfig if it doesn't exist
                        if (!openshift.selector("dc", "cursor-app").exists()) {
                            openshift.newApp("cursor-app", "--name=cursor-app")
                        }
                        // Trigger a rollout
                        def dc = openshift.selector("dc", "cursor-app")
                        dc.rollout().latest()
                    }
                }
            }
        }

        // Stage 3: Expose the Route (if not already done)
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
