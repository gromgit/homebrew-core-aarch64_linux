class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.30.tar.gz"
  sha256 "5257d9e2279f6a7cc03272cb1764d835a2843546012fa32663ca16ce15967d70"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "635166d111e5307c7c08723410e780bceb8d76fe9202a1b887e020792b629ac2"
    sha256 cellar: :any_skip_relocation, big_sur:       "506ab97e915ac5a37789ee8cc31f1f94d59a0aee60556783b8c56b37d78bb453"
    sha256 cellar: :any_skip_relocation, catalina:      "1317737abc28dec83276817b4b96985d1c500afa09afee3e92677dacea5a3ce0"
    sha256 cellar: :any_skip_relocation, mojave:        "6045ae32a8df24a75b3c4ed01e0394c756ebe1ef420a5b755466ccd7907c9553"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "-o", bin/"mp"
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
