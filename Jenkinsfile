```groovy
pipeline {

    agent any

    environment {

        // =================================================
        // Docker Hub
        // =================================================

        FRONTEND_IMAGE = "vinitparmar03/ecommerce-frontend"
        BACKEND_IMAGE  = "vinitparmar03/ecommerce-backend"


        // =================================================
        // Persistent Version Storage
        // =================================================

        VERSION_DIR = "/var/lib/jenkins/version-store"

        FRONTEND_VERSION_FILE =
            "/var/lib/jenkins/version-store/frontend.version"

        BACKEND_VERSION_FILE =
            "/var/lib/jenkins/version-store/backend.version"


        // =================================================
        // Kubernetes
        // =================================================

        K8S_NAMESPACE = "default"
        MONITORING_NAMESPACE = "monitoring"
    }


    stages {

        // =================================================
        // 1. CHECKOUT
        // =================================================

        stage('Checkout') {

            steps {

                checkout scm

            }
        }


        // =================================================
        // 2. FRONTEND
        // =================================================

        stage('Frontend') {

            when {
                changeset "frontend/**"
            }

            stages {

                // =========================================
                // Frontend Version
                // =========================================

                stage('Frontend Version') {

                    steps {

                        script {

                            sh """
                                mkdir -p "${VERSION_DIR}"

                                if [ ! -f "${FRONTEND_VERSION_FILE}" ]; then
                                    echo 0 > "${FRONTEND_VERSION_FILE}"
                                fi
                            """

                            def version = sh(
                                script: "cat '${FRONTEND_VERSION_FILE}'",
                                returnStdout: true
                            ).trim().toInteger()

                            version++

                            sh """
                                echo "${version}" > "${FRONTEND_VERSION_FILE}"
                            """

                            env.FRONTEND_VERSION =
                                version.toString()

                            echo "Frontend version: ${env.FRONTEND_VERSION}"
                        }
                    }
                }


                // =========================================
                // Frontend Docker Build
                // =========================================

                stage('Frontend Docker Build') {

                    steps {

                        withCredentials([
                            string(
                                credentialsId: 'razorpay-key-id',
                                variable: 'RAZORPAY_KEY_ID'
                            )
                        ]) {

                            sh '''
                                docker build \
                                --build-arg REACT_APP_RAZORPAY_KEY_ID="$RAZORPAY_KEY_ID" \
                                -t "$FRONTEND_IMAGE:$FRONTEND_VERSION" \
                                ./frontend
                            '''
                        }
                    }
                }


                // =========================================
                // Frontend Docker Push
                // =========================================

                stage('Frontend Docker Push') {

                    steps {

                        withCredentials([
                            usernamePassword(
                                credentialsId: 'dockerhub-credentials',
                                usernameVariable: 'DOCKER_USERNAME',
                                passwordVariable: 'DOCKER_PASSWORD'
                            )
                        ]) {

                            sh '''
                                echo "$DOCKER_PASSWORD" | \
                                docker login \
                                  --username "$DOCKER_USERNAME" \
                                  --password-stdin

                                docker push \
                                  "$FRONTEND_IMAGE:$FRONTEND_VERSION"

                                docker logout
                            '''
                        }
                    }
                }


                // =========================================
                // Deploy Frontend
                // =========================================

                stage('Deploy Frontend') {

                    steps {

                        sh """
                            kubectl set image \
                              deployment/frontend-deployment \
                              frontend=${FRONTEND_IMAGE}:${FRONTEND_VERSION} \
                              -n ${K8S_NAMESPACE}

                            kubectl rollout status \
                              deployment/frontend-deployment \
                              -n ${K8S_NAMESPACE}
                        """
                    }
                }
            }
        }


        // =================================================
        // 3. BACKEND
        // =================================================

        stage('Backend') {

            when {
                changeset "backend/**"
            }

            stages {

                // =========================================
                // Backend Version
                // =========================================

                stage('Backend Version') {

                    steps {

                        script {

                            sh """
                                mkdir -p "${VERSION_DIR}"

                                if [ ! -f "${BACKEND_VERSION_FILE}" ]; then
                                    echo 0 > "${BACKEND_VERSION_FILE}"
                                fi
                            """

                            def version = sh(
                                script: "cat '${BACKEND_VERSION_FILE}'",
                                returnStdout: true
                            ).trim().toInteger()

                            version++

                            sh """
                                echo "${version}" > "${BACKEND_VERSION_FILE}"
                            """

                            env.BACKEND_VERSION =
                                version.toString()

                            echo "Backend version: ${env.BACKEND_VERSION}"
                        }
                    }
                }


                // =========================================
                // Backend Docker Build
                // =========================================

                stage('Backend Docker Build') {

                    steps {

                        sh """
                            docker build \
                              -t ${BACKEND_IMAGE}:${BACKEND_VERSION} \
                              ./backend
                        """
                    }
                }


                // =========================================
                // Backend Docker Push
                // =========================================

                stage('Backend Docker Push') {

                    steps {

                        withCredentials([
                            usernamePassword(
                                credentialsId: 'dockerhub-credentials',
                                usernameVariable: 'DOCKER_USERNAME',
                                passwordVariable: 'DOCKER_PASSWORD'
                            )
                        ]) {

                            sh '''
                                echo "$DOCKER_PASSWORD" | \
                                docker login \
                                  --username "$DOCKER_USERNAME" \
                                  --password-stdin

                                docker push \
                                  "$BACKEND_IMAGE:$BACKEND_VERSION"

                                docker logout
                            '''
                        }
                    }
                }


                // =========================================
                // Update Kubernetes Secrets
                // =========================================

                stage('Update Kubernetes Secrets') {

                    steps {

                        withCredentials([

                            // ---------------------------------
                            // JWT
                            // ---------------------------------

                            string(
                                credentialsId: 'jwt-secret',
                                variable: 'JWT_SECRET'
                            ),

                            // ---------------------------------
                            // MongoDB
                            // ---------------------------------

                            string(
                                credentialsId: 'mongo-uri',
                                variable: 'MONGO_URI'
                            ),

                            // ---------------------------------
                            // Google OAuth
                            // ---------------------------------

                            string(
                                credentialsId: 'google-client-id',
                                variable: 'GOOGLE_CLIENT_ID'
                            ),

                            string(
                                credentialsId: 'google-client-secret',
                                variable: 'GOOGLE_CLIENT_SECRET'
                            ),

                            // ---------------------------------
                            // Cloudinary
                            // ---------------------------------

                            string(
                                credentialsId: 'cloudinary-cloud-name',
                                variable: 'CLOUDINARY_CLOUD_NAME'
                            ),

                            string(
                                credentialsId: 'cloudinary-api-key',
                                variable: 'CLOUDINARY_API_KEY'
                            ),

                            string(
                                credentialsId: 'cloudinary-api-secret',
                                variable: 'CLOUDINARY_API_SECRET'
                            ),

                            // ---------------------------------
                            // Gmail
                            // ---------------------------------

                            string(
                                credentialsId: 'gmail-user',
                                variable: 'GMAIL_USER'
                            ),

                            string(
                                credentialsId: 'gmail-pass',
                                variable: 'GMAIL_PASS'
                            ),

                            // ---------------------------------
                            // Razorpay
                            // ---------------------------------

                            string(
                                credentialsId: 'razorpay-key-id',
                                variable: 'RAZORPAY_KEY_ID'
                            ),

                            string(
                                credentialsId: 'razorpay-key-secret',
                                variable: 'RAZORPAY_KEY_SECRET'
                            )

                            // ---------------------------------
                            // Razorpay
                            // ---------------------------------

                            string(
                                credientialId: 'frontend-url',
                                variable: 'FRONTEND_URL'
                            )

                            string(
                                credientialId: 'node-env',
                                variable: 'NODE_ENV'
                            )

                            string(
                                credientialId: 'port',
                                variable: 'PORT'
                            )

                        ]) {

                            sh '''
                                set +x

                                # =================================
                                # Authentication Secret
                                # =================================

                                kubectl create secret generic authentication-secret \
                                  --from-literal=JWT_SECRET="$JWT_SECRET" \
                                  --dry-run=client \
                                  -o yaml | \
                                  kubectl apply -f -


                                # =================================
                                # MongoDB Secret
                                # =================================

                                kubectl create secret generic mongodb-secret \
                                  --from-literal=MONGO_URI="$MONGO_URI" \
                                  --dry-run=client \
                                  -o yaml | \
                                  kubectl apply -f -


                                # =================================
                                # Google OAuth Secret
                                # =================================

                                kubectl create secret generic google-secret \
                                  --from-literal=GOOGLE_CLIENT_ID="$GOOGLE_CLIENT_ID" \
                                  --from-literal=GOOGLE_CLIENT_SECRET="$GOOGLE_CLIENT_SECRET" \
                                  --dry-run=client \
                                  -o yaml | \
                                  kubectl apply -f -


                                # =================================
                                # Cloudinary Secret
                                # =================================

                                kubectl create secret generic cloudinary-secret \
                                  --from-literal=CLOUDINARY_CLOUD_NAME="$CLOUDINARY_CLOUD_NAME" \
                                  --from-literal=CLOUDINARY_API_KEY="$CLOUDINARY_API_KEY" \
                                  --from-literal=CLOUDINARY_API_SECRET="$CLOUDINARY_API_SECRET" \
                                  --dry-run=client \
                                  -o yaml | \
                                  kubectl apply -f -


                                # =================================
                                # Gmail Secret
                                # =================================

                                kubectl create secret generic gmail-secret \
                                  --from-literal=GMAIL_USER="$GMAIL_USER" \
                                  --from-literal=GMAIL_PASS="$GMAIL_PASS" \
                                  --dry-run=client \
                                  -o yaml | \
                                  kubectl apply -f -


                                # =================================
                                # Razorpay Secret
                                # =================================

                                kubectl create secret generic razorpay-secret \
                                  --from-literal=RAZORPAY_KEY_ID="$RAZORPAY_KEY_ID" \
                                  --from-literal=RAZORPAY_KEY_SECRET="$RAZORPAY_KEY_SECRET" \
                                  --dry-run=client \
                                  -o yaml | \
                                  kubectl apply -f -
                                  

                                # =================================
                                # Backend Secret
                                # =================================

                                kubectl create configmap backend-config \\
                                  --from-literal=FRONTEND_URL="$FRONTEND_URL" \\
                                  --from-literal=NODE_ENV="$NODE_ENV" \\
                                  --from-literal=PORT="$PORT" \\
                                  --dry-run=client \\
                                  -o yaml | \\
                                  kubectl apply -f -
                            '''
                        }
                    }
                }


                // =========================================
                // Deploy Backend
                // =========================================

                stage('Deploy Backend') {

                    steps {

                        sh """
                            kubectl set image \
                              deployment/backend-deployment \
                              backend=${BACKEND_IMAGE}:${BACKEND_VERSION} \
                              -n ${K8S_NAMESPACE}

                            kubectl rollout status \
                              deployment/backend-deployment \
                              -n ${K8S_NAMESPACE}
                        """
                    }
                }
            }
        }


        // =================================================
        // 4. KUBERNETES CONFIGURATION
        // =================================================

        stage('Kubernetes Configuration') {

            when {
                changeset "k8s/**"
            }

            steps {

                sh """
                    kubectl apply \
                      -f k8s/frontend/ \
                      -n ${K8S_NAMESPACE}

                    kubectl apply \
                      -f k8s/backend/ \
                      -n ${K8S_NAMESPACE}

                    kubectl apply \
                      -f k8s/ingress.yaml \
                      -n ${K8S_NAMESPACE}
                """
            }
        }


        // =================================================
        // 5. MONITORING
        // =================================================

        stage('Monitoring') {

            when {
                changeset "k8s/monitoring/**"
            }

            stages {

                // =========================================
                // Helm values changed
                // =========================================

                stage('Upgrade Monitoring Stack') {

                    when {
                        changeset "k8s/monitoring/values.yaml"
                    }

                    steps {

                        sh """
                            helm upgrade --install monitoring \
                              prometheus-community/kube-prometheus-stack \
                              --namespace ${MONITORING_NAMESPACE} \
                              --create-namespace \
                              -f k8s/monitoring/values.yaml
                        """

                        sh """
                            kubectl apply \
                              -f k8s/monitoring/service_monitor.yaml \
                              -n ${MONITORING_NAMESPACE}
                        """
                    }
                }


                // =========================================
                // ServiceMonitor changed
                // =========================================

                stage('Apply ServiceMonitor') {

                    when {
                        changeset "k8s/monitoring/servicemonitor.yaml"
                    }

                    steps {

                        sh """
                            kubectl apply \
                              -f k8s/monitoring/servicemonitor.yaml \
                              -n ${MONITORING_NAMESPACE}
                        """
                    }
                }
            }
        }

    }


    // =====================================================
    // POST
    // =====================================================

    post {

        success {

            echo "=========================================="
            echo "Pipeline completed successfully"
            echo "=========================================="

        }

        failure {

            echo "=========================================="
            echo "Pipeline failed"
            echo "=========================================="

        }

        always {

            echo "Cleaning Jenkins workspace..."

            cleanWs()
        }
    }
}
```