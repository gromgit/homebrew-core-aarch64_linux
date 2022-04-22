require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.5.1.tar.gz"
  sha256 "1611da0f2632545c780ff5b7b61007ed7ba6cab352388214cac08b6df21bb9b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7275165f2aaa649a51036f05e40ee0ca1ef0ae4b9de590a41bb30efd9edd3c24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bc02a542abb01fb9412a96101bd35c09795b0900f3e9813bcb41322f7b53614"
    sha256 cellar: :any_skip_relocation, monterey:       "98b17a309e619e4929a360995dfa957a669751acf45280b682e80bb2c6c86148"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d5b4274a3d9baee7be9cdc970476822a1f09e242443232eb16d3d3f3a82a54e"
    sha256 cellar: :any_skip_relocation, catalina:       "ab22f8a01e93b16b45b80a4e1d146ba3178c34e96c30fbf99f18f41cb202a421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d772d1f326b1e408054f95c2987bcca0073684ffed11112e8916a72d1ade255"
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
