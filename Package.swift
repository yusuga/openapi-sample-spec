// swift-tools-version:6.0
import PackageDescription

let HTTPBingoClient = "HTTPBingoClient"
let PostmanEchoClient = "PostmanEchoClient"

let MyServiceAPIClientNames = [
  "MyServiceAPIClient"
]

let MyServiceAPIServerNames = [
  "MyServiceUserAPIServer",
  "MyServiceStoreAPIServer",
]

func generateAPITargets(
  for names: [String]
) -> [Target] {
  names.map {
    .target(
      name: $0,
      dependencies: [
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
      ],
      resources: [
        .copy("openapi.yaml"),
      ],
      plugins: [
        .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
      ]
    )
  }
}

let apiTargets: [Target] = generateAPITargets(
  for: [HTTPBingoClient, PostmanEchoClient]
) + generateAPITargets(
  for: MyServiceAPIClientNames
) + generateAPITargets(
  for: MyServiceAPIServerNames
)

let package = Package(
  name: "openapi-sample-spec",
  platforms: [
    .macOS(.v13),
    .iOS(.v17),
  ],
  products: [
    .library(
      name: HTTPBingoClient,
      targets: [HTTPBingoClient]
    ),
    .library(
      name: PostmanEchoClient,
      targets: [PostmanEchoClient]
    ),
    .library(
      name: "MyServiceAPIClient",
      targets: MyServiceAPIClientNames
    ),
    .library(
      name: "MyServiceAPIServer",
      targets: MyServiceAPIServerNames
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.6.0"),
    .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.5.0"),
    .package(url: "https://github.com/vapor/vapor.git", from: "4.99.3"),
  ],
  targets: [
    .executableTarget(
      name: "Example",
      dependencies: [
        .product(name: "Vapor", package: "vapor"),
      ] + ([HTTPBingoClient, PostmanEchoClient] + MyServiceAPIClientNames + MyServiceAPIServerNames)
        .map { .target(name: $0) }
    ),
  ] as [Target] + apiTargets
)
