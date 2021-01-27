class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.6.1.tar.gz"
  sha256 "eef150a425aa4eaa8b2e36a75ee400d4247525403f79e24ed32ccb346dc653ff"
  license "MIT"
  head "https://github.com/tomnomnom/gron.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "18f72c72d99203bd58c670642d6c33fa9e1f67e6861212ba21f98b975df406f0" => :big_sur
    sha256 "dc6b46a589f618ab5b2e9d4aea01bd75f0326f585085c3b1f12e266dda2e7e5d" => :catalina
    sha256 "2a0ad03c4c7dfd2098758be2c5b65f16107ce8c67b586a4679f9d871aaee09a7" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/gron", "{\"foo\":1, \"bar\":2}")
      json = {};
      json.bar = 2;
      json.foo = 1;
    EOS
  end
end
