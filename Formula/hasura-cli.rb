require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.8.3.tar.gz"
  sha256 "cdd6eb5485496546565ae8a6f46c5aaf464802d9119103417037910dfab0b8cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59badc8f49e28982e217ea2fb0af6e7dda23132fa6ef93a5b3a6fb4443a2bc86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcb736318a7a968c919a2f9f51e5e675a13e9fb9739bcc3b06f1153b0c5cf3b9"
    sha256 cellar: :any_skip_relocation, monterey:       "be9a3098647896e258dd34c38caf5cf793cba20a7949014f948663fbe3af3585"
    sha256 cellar: :any_skip_relocation, big_sur:        "448f0ec775bc839a20f084e9f55943caa816f1209708d9f81b0566a4a52ce345"
    sha256 cellar: :any_skip_relocation, catalina:       "7696fdbf181f98380a6fbea22b7fe4383a691186a78f3496d5c675e9c07bd248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "137050dea150457d17590b5b0ca3a25fa63ac0fb1ed5e4d86160df57ef07f2d6"
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
