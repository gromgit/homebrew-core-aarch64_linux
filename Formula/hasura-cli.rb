require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.9.0.tar.gz"
  sha256 "504a2fff7680067a74e1268a5d26f19ab29242374547deca1b14b28bf56b0c46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "242fc4c617f37d7bf8600c94432ef4a0f8db77dac2de5fae975444a2c34343f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3117a52c5d1f4e985da81d537dc3fd4910f9e0052815b0f7ccaaaae44711d63"
    sha256 cellar: :any_skip_relocation, monterey:       "09add85f24fbe3a96efe8cf831a9331257441e25b2ccce1acc0f0d12efa87ea2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8502380ce6356abebae284e6f1643e93f5b74bca81aa1d626928765ed5f5406d"
    sha256 cellar: :any_skip_relocation, catalina:       "87c1f9365c267b50d55b5ce551f6a97614e9c2b9ff861936d12cd030e689227e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d23ef932c6cb0777a0cd69227801db2f7f3aa580708aace4c54d3438b8babd"
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
