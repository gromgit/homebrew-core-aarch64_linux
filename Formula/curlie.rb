class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https://curlie.io"
  url "https://github.com/rs/curlie/archive/v1.6.0.tar.gz"
  sha256 "7ed115d9d785e587f426e5d7f1e408ce687ed61389b63398fce0e60f3a5f3df8"
  license "MIT"

  depends_on "go" => :build

  uses_from_macos "curl"

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "httpbin.org",
      shell_output("#{bin}/curlie -X GET httpbin.org/headers 2>&1")
  end
end
