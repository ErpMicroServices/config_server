# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this module.

## Module Overview

The `config_server` module is a Spring Cloud Config Server that provides centralized configuration management for all microservices in the ERP system. It serves externalized configuration properties from a central location, supporting multiple environments and dynamic configuration updates.

## Technology Stack

- **Framework**: Spring Boot with Spring Cloud Config Server
- **Java Version**: Modern Java (based on Gradle configuration)
- **Build Tool**: Gradle
- **Security**: Spring Security for configuration access control
- **Configuration Storage**: File-based configuration repository
- **Container**: Docker support available

## Project Structure

```
config_server/
├── build.gradle                # Gradle build configuration
├── settings.gradle             # Gradle settings
├── gradlew / gradlew.bat      # Gradle wrapper scripts
├── Dockerfile                 # Docker container configuration
├── gradle/wrapper/            # Gradle wrapper files
└── src/
    ├── main/
    │   ├── java/org/erpmicroservices/server/config/
    │   │   ├── ConfigurationServerApplication.java
    │   │   └── SecurityConfiguration.java
    │   └── resources/
    │       ├── application.yml           # Config server settings
    │       ├── config-server.jks         # Security keystore
    │       └── config/                   # Client configurations
    │           └── people_and_organizations-endpoint-rest-development.yml
    └── test/
        └── java/                        # Test classes
```

## Build and Development Commands

### Gradle Commands
```bash
# Build the project
./gradlew build

# Run the config server
./gradlew bootRun

# Run tests
./gradlew test

# Build Docker image
docker build -t erpmicroservices/config_server .

# Clean build artifacts
./gradlew clean
```

### Docker Operations
```bash
# Build container
docker build -t erpmicroservices/config_server .

# Run container
docker run -p 8888:8888 erpmicroservices/config_server
```

## Configuration Management

### Server Configuration (`application.yml`)
- **Port Configuration**: Default port 8888
- **Security Settings**: Authentication and authorization rules
- **Repository Configuration**: File system configuration location
- **SSL/TLS Settings**: Secure communication configuration

### Client Configuration Storage
Configurations are stored in `src/main/resources/config/`:
- **Environment-based**: `{application}-{profile}.yml`
- **Application-specific**: Service-specific configuration files
- **Profile Support**: Development, staging, production profiles

### Security Configuration
- **Keystore**: `config-server.jks` for SSL/TLS encryption
- **Authentication**: Spring Security for access control
- **Authorization**: Role-based configuration access
- **Encryption**: Support for encrypted property values

## Development Workflow

### Adding New Service Configurations
1. **Create Configuration File**: Add `{service-name}-{profile}.yml` to `config/` directory
2. **Define Properties**: Add service-specific configuration properties
3. **Environment Variants**: Create profile-specific variants as needed
4. **Test Configuration**: Verify configuration loading via REST endpoints
5. **Document Changes**: Update configuration documentation

### Configuration Properties Organization
```yaml
# Database configuration
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/database
    username: ${DB_USER:user}
    password: ${DB_PASSWORD:password}

# Service-specific configuration  
service:
  feature-flags:
    new-feature: true
  external-api:
    timeout: 30s
```

### Updating Existing Configurations
1. **Backup Current**: Keep backup of working configurations
2. **Update Properties**: Modify configuration files
3. **Test Changes**: Verify with affected services
4. **Deploy**: Update config server with new configurations
5. **Refresh Services**: Trigger configuration refresh on client services

## Client Integration

### Service Configuration
Client services connect to config server:
```yaml
spring:
  application:
    name: service-name
  config:
    import: configserver:http://config-server:8888
  profiles:
    active: development
```

### Configuration Refresh
- **Actuator Refresh**: `/actuator/refresh` endpoint for configuration updates
- **Bus Refresh**: Spring Cloud Bus for distributed configuration updates
- **Webhook Support**: Git webhook integration for automatic updates

## REST API Endpoints

### Configuration Access
```bash
# Get configuration for application and profile
GET /{application}/{profile}

# Get specific configuration file
GET /{application}-{profile}.yml

# Get configuration with label
GET /{application}/{profile}/{label}
```

### Health and Management
```bash
# Health check
GET /actuator/health

# Info endpoint
GET /actuator/info

# Configuration properties
GET /actuator/configprops
```

## Security Configuration

### Access Control
- **Authentication**: Basic authentication for configuration access
- **Authorization**: Role-based access to different configurations
- **SSL/TLS**: Encrypted communication between config server and clients
- **Property Encryption**: Sensitive values encrypted at rest

### Security Best Practices
- **Keystore Management**: Secure keystore file handling
- **Access Logs**: Audit configuration access requests
- **Network Security**: Restrict network access to config server
- **Secret Management**: External secret management integration

## Environment Management

### Profile-based Configuration
- **Development**: Local development settings
- **Staging**: Pre-production environment settings  
- **Production**: Production environment settings
- **Testing**: Automated testing configurations

### Property Precedence
1. **Command Line Arguments**: Highest precedence
2. **Environment Variables**: OS environment variables
3. **Config Server**: Centralized configuration
4. **Application Properties**: Default application settings

## Docker Integration

### Container Configuration
- **Port Exposure**: Exposes config server port (8888)
- **Volume Mapping**: Configuration files can be externalized
- **Environment Variables**: Runtime configuration override
- **Health Checks**: Container health check endpoints

### Production Deployment
- **High Availability**: Multiple config server instances
- **Load Balancing**: Load balancer configuration
- **Backup Strategy**: Configuration backup and recovery
- **Monitoring**: Configuration server monitoring and alerting

## Testing Standards

### Configuration Testing
- **Property Loading**: Test configuration property loading
- **Profile Resolution**: Test profile-specific configuration
- **Security Testing**: Test access control and authentication
- **Integration Testing**: Test with client services

### Test Configuration
- **Test Profiles**: Dedicated test configurations
- **Mock Services**: Mock external dependencies in test configs
- **Test Data**: Test-specific database and service configurations

## Integration Points

### Service Discovery
- **Registration**: Config server registration with service discovery
- **Client Discovery**: Services discover config server location
- **Failover**: Fallback configuration strategies

### Monitoring and Logging
- **Access Logs**: Configuration access audit trails
- **Performance Metrics**: Configuration serving performance
- **Error Monitoring**: Configuration error tracking and alerting

## Performance Considerations

### Caching Strategy
- **Server-side Caching**: Cache frequently accessed configurations
- **Client-side Caching**: Client-side configuration caching
- **Cache Invalidation**: Proper cache invalidation strategies

### Scalability
- **Horizontal Scaling**: Multiple config server instances
- **Load Distribution**: Efficient configuration distribution
- **Resource Optimization**: Memory and CPU optimization

## Important Notes

- **Central Configuration**: Single source of truth for all service configurations
- **Environment Isolation**: Proper separation of environment-specific settings
- **Security Critical**: Secure handling of sensitive configuration data
- **High Availability**: Critical infrastructure component requiring reliability
- **Change Management**: Proper change control for configuration updates
- **Backward Compatibility**: Maintain compatibility with existing services
- **Documentation**: Keep configuration documentation current and comprehensive