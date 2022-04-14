require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.5.0.tar.gz"
  sha256 "5618062db5ccc80f90cfe453c3cfb55ccef1a71f4fcabcbb87e7629961d7d7f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3f9b3e729a21e1553139e6f1c27aa53dbcc8dece9ee1fa056ad2fa00374a617"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7a43879fb89415c54bb39a6ca57c6c25170d6f579a4d7a2a9479b33e7c73cb7"
    sha256 cellar: :any_skip_relocation, monterey:       "ebcac380edc8a784ea7cca9384c7cf7554b221eb92dfc7edf4137dea130faa34"
    sha256 cellar: :any_skip_relocation, big_sur:        "5651bbec7aef2c167a963845cb934a265bc65d4585591156967901031e830c30"
    sha256 cellar: :any_skip_relocation, catalina:       "ac7ebcfe9b62cded3b72f5bf19568674e37908a88e2c8e492816c8cda8dcbdc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce3dc77f9e0e842de213eb1d6f757667d185027afbd24d121fe0b81ff6fefc60"
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
