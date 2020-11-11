class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v1.3.3.tar.gz"
  sha256 "816e46e09a21a2f2fd0d95b05373198416704035c0302fd1c07bffa5a5e04099"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f401fa465f27d50d1fcd467d53b2db03790f8248527514b49ca867679a622b5b" => :catalina
    sha256 "62bf68a7d5118c8547849272425dcd49fa2be3847236cef3c3ca4e4233c972be" => :mojave
    sha256 "1eae260ad4598bf74d835bf0923ef8323713e367d7389a4febb5134b7c821a33" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/plugins.IndexBranchRef=master
    ]

    cd "cli" do
      system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "-o", bin/"hasura", "./cmd/hasura/"

      system bin/"hasura", "completion", "bash", "--file", "completion_bash"
      bash_completion.install "completion_bash" => "hasura"

      system bin/"hasura", "completion", "zsh", "--file", "completion_zsh"
      zsh_completion.install "completion_zsh" => "_hasura"
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
