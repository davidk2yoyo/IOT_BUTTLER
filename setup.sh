#!/bin/bash

echo "🤖 Setting up IoT Butler project..."

# Create Serverpod project
serverpod create iot_butler

cd iot_butler

# Generate initial database migration
cd iot_butler_server
dart bin/main.dart --create-migration

echo "✅ Project created!"
echo "Next steps:"
echo "1. cd iot_butler_server && dart bin/main.dart"
echo "2. cd iot_butler_flutter && flutter run"