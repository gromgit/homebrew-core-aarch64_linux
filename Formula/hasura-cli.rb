require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.11.0.tar.gz"
  sha256 "48863bb0fe86938c84736e2a9d710bea3ab75bc1f4f95723851cc7e23b0bfcfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b9a52122aa99d5e9cc75d9e636f474c2034a24afbc70ef2771dbc4877061c3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e871ae0c0b7d32aad150137e090a2eb0fba9c05ca72b1b052710bd2d880f7d9e"
    sha256 cellar: :any_skip_relocation, monterey:       "1f96692a37d1e6657e0436343e2eebc3e6a50b50541a4c156c78dd60bc2e1a29"
    sha256 cellar: :any_skip_relocation, big_sur:        "507222e424829fbe7c2097988ddbad936a753b67ef0d9597ad2bd44c42848b26"
    sha256 cellar: :any_skip_relocation, catalina:       "c62f1f5a8a8d19ade6e7f9657f425ec6d0528cdb32777cc26533c45373645e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cca345c17d5e0f336bceb4341c140f27dace6b6ce4458e5e089914317a74035"
  end

  depends_on "go" => :build
  depends_on "node@16" => :build # Switch back to node with https://github.com/vercel/pkg/issues/1364

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ]

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "prebuild"
      system "./node_modules/.bin/pkg", "./build/command.js", "--output", "./bin/cli-ext-hasura", "-t", "host"
    end

    cd "cli" do
      arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
      os = OS.kernel_name.downcase

      cp "../cli-ext/bin/cli-ext-hasura", "./internal/cliext/static-bin/#{os}/#{arch}/cli-ext"
      system "go", "build", *std_go_args(output: bin/"hasura", ldflags: ldflags), "./cmd/hasura/"

      output = Utils.safe_popen_read("#{bin}/hasura", "completion", "bash")
      (bash_completion/"hasura").write output
      output = Utils.safe_popen_read("#{bin}/hasura", "completion", "zsh")
      (zsh_completion/"_hasura").write output
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
