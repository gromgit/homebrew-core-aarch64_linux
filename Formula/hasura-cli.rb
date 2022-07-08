require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.8.4.tar.gz"
  sha256 "7c3a16008b67db48eaf07fd83a6c8e0e32655b021cddbb757f478208b007f65a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3d9cac53123e981d177bae2a42da165f8ea6df85fa6f89af49d280d8155a08b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37d667a08b8605948d40019a249f5ac6fe2076a581235efff48a3a6ba3d4f81a"
    sha256 cellar: :any_skip_relocation, monterey:       "f56065eeb261aae6d6bb1cfd414f1c069d81165d8380646fc2cb0672d2e89597"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8db2caf108e35dffaa231bd1a8013c70c19999d8903245516afc54fbd5adee4"
    sha256 cellar: :any_skip_relocation, catalina:       "0c945b3e02094e61e9b4981e2a19fb8d0de17a8faefdb2408ba26a6412ccaf7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7dc0948e8a3f1a3383dd6605c966dacec6a05b2855b161fab850ca3a1b1d47a"
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
