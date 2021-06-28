class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://github.com/imgproxy/imgproxy/archive/v2.16.5.tar.gz"
  sha256 "1d5cae37c87cd5837c2d5ff01f8c97e34ea740a69e4179b2d29676995ca3fa52"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7b18cae1cef96dc60a8c0518fb5da660edebdcf392b33c0cd98824f9ce589111"
    sha256 cellar: :any, big_sur:       "43d2baed86545f438ccd2477b5959e35d33024c58faa34adca380372cc45e0eb"
    sha256 cellar: :any, catalina:      "df8155317fe90e6c885eda20b7442e55e10c75ca0461e3ca0f615d7699def207"
    sha256 cellar: :any, mojave:        "27a4d00f4e088dd853dba97e95535118bf51c105f43a5e93039b1839e7225315"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "vips"

  def install
    ENV["CGO_LDFLAGS_ALLOW"]="-s|-w"
    ENV["CGO_CFLAGS_ALLOW"]="-Xpreprocessor"

    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    cp(test_fixtures("test.jpg"), testpath/"test.jpg")

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = fork do
      exec bin/"imgproxy"
    end
    sleep 10

    output = testpath/"test-converted.png"

    system "curl", "-s", "-o", output,
           "http://127.0.0.1:#{port}/insecure/fit/100/100/no/0/plain/local:///test.jpg@png"
    assert_equal 0, $CHILD_STATUS
    assert_predicate output, :exist?

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "1 x 1", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
