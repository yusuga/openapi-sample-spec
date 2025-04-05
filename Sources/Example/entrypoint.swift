import Vapor

import HTTPBingoClient
import PostmanEchoClient

import MyServiceAPIClient
import MyServiceUserAPIServer
import MyServiceStoreAPIServer

@main
enum Entrypoint {

  static func main() async throws {
    var env = try Environment.detect()
    try LoggingSystem.bootstrap(from: &env)

    let app = try await Application.make(env)
    try await app.execute()
    try await app.asyncShutdown()
  }
}
