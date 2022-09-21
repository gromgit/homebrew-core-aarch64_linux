class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.34.tar.gz"
  sha256 "289b3df07b3847fecb0d815ff552dad1b1b1e4f662eddc898ca7b1e7d81d6d7c"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/microplane"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "408fe17306a7b2a8230f160380f8ddb6570e59e8f65917f3f51f8ec25d78596f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"mp", ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    # mandatory env variable
    ENV["GITHUB_API_TOKEN"] = "test"
    # create repos.txt
    (testpath/"repos.txt").write <<~EOF
      hashicorp/terraform
    EOF
    # create mp/init.json
    shell_output("mp init -f #{testpath}/repos.txt")
    # test command
    output = shell_output("mp plan -b microplaning -m 'microplane fun' -r terraform -- sh echo 'hi' 2>&1")
    assert_match "planning", output
  end
end
