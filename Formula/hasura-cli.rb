require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.6.1.tar.gz"
  sha256 "63429ae4d974a90544649ae22c92072315fc079984deb86d5f1628c9e0fc68a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "552b2c465dc4336d624e871e6ca55d635005c2c98bda7a70c2554fdd4ff145d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0887779a3cf5ca5c72b2de9a0f21f940b12ea39a198931c9e64209100eaeefee"
    sha256 cellar: :any_skip_relocation, monterey:       "1ab557a10802c30b3cb403959bc9531e61985b37d1619a7c97a33065da9dc767"
    sha256 cellar: :any_skip_relocation, big_sur:        "9faa11ce34100e6ffcafefe7680d84b71d873aa82de14f4051c4a2793f634900"
    sha256 cellar: :any_skip_relocation, catalina:       "64cf01b8c8718e50456fdd0ad09edf011fc7f598a6b75be33e217814fc969ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "401881cb246913bcaa3407e7c3b2e67d484d00cb2b8d28fa333a24cd0712d5e2"
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
