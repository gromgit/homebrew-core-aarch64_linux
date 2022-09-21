require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.6.1.tar.gz"
  sha256 "63429ae4d974a90544649ae22c92072315fc079984deb86d5f1628c9e0fc68a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd2a3a75aaab3e95373704ca602987967639f1d074cf145739a272b58eb1916d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e9237c3e3718521fe02fefefb15531f8af5e6e9726724e1cdf993b8bfb1695a"
    sha256 cellar: :any_skip_relocation, monterey:       "73a0b6e7badb4573fd23674120e72b11decb0821a4a5fd9241c05e592fbfdd8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7afd69af36f3e59b4a72b6ee4720db0818ee758d730bd7b30afcffa9a19022b0"
    sha256 cellar: :any_skip_relocation, catalina:       "1e91f9635c728fd6f95bc78b63ba6e502829dac2dea5a7a62c6ee2bc1dab4ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a00ffa4067810ea713f48de044b101b98a55f93914c8e282bcb3b46bf04ecf5"
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
