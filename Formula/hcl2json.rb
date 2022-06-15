class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/v0.3.4.tar.gz"
  sha256 "41c63b892e9a1488c5380faee83d341482352199175588fb46fa838f3b75e6a3"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/hcl2json"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d7ec1fe84f4c19aee299dd461b6826062b997d551f6cb7d090414f2a8fd2b4c0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    test_hcl = <<~HCL
      resource "my_resource_type" "test_resource" {
        input = "magic_test_value"
      }
    HCL

    test_json = {
      resource: {
        my_resource_type: {
          test_resource: [
            {
              input: "magic_test_value",
            },
          ],
        },
      },
    }.to_json

    assert_equal test_json, pipe_output("#{bin}/hcl2json", test_hcl).gsub(/\s+/, "")
    assert_match "Failed to convert", pipe_output("#{bin}/hcl2json 2>&1", "Hello, Homebrew!", 1)
  end
end
