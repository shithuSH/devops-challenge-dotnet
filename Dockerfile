#Build
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /app

# Copy the solution file and restore dependencies
COPY DevOpsChallenge.SalesApi.sln ./
COPY src/DevOpsChallenge.SalesApi/DevOpsChallenge.SalesApi.csproj ./src/DevOpsChallenge.SalesApi/
COPY src/DevOpsChallenge.SalesApi.Database/DevOpsChallenge.SalesApi.Database.csproj ./src/DevOpsChallenge.SalesApi.Database/
COPY src/DevOpsChallenge.SalesApi.Business/DevOpsChallenge.SalesApi.Business.csproj ./src/DevOpsChallenge.SalesApi.Business/
COPY tests/DevOpsChallenge.SalesApi.Business.UnitTests/DevOpsChallenge.SalesApi.Business.UnitTests.csproj ./tests/DevOpsChallenge.SalesApi.Business.UnitTests/
COPY tests/DevOpsChallenge.SalesApi.IntegrationTests/DevOpsChallenge.SalesApi.IntegrationTests.csproj ./tests/DevOpsChallenge.SalesApi.IntegrationTests/
RUN dotnet restore

# Copy the source code and build the project
COPY . ./
RUN dotnet build src/DevOpsChallenge.SalesApi/DevOpsChallenge.SalesApi.csproj --configuration Release --output /app/build

#Run
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build-env /app/build .

# Expose port 80 for the application
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "DevOpsChallenge.SalesApi.dll"]