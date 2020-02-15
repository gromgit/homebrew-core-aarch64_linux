class Antibody < Formula
  desc "The fastest shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v4.3.1.tar.gz"
  sha256 "b69b2b90914e03f4a54453d740345cad222b379c366ec3788f4fdf4b1f01ac64"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9272b167bef22b1e37d9b48be0e8a260569402bd27f69b869f0986b485ac6c3" => :catalina
    sha256 "0cbe9cd2950a85113caf84ebc4227f8ac9f32c130346ae2ea733c96d7fc7c829" => :mojave
    sha256 "57a9c27a9c51809d02b6c12c8edd2337ed2cc750cf6d676712b8bb9e6ae6b64f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"antibody"
  end

  test do
    # See if antibody can install a bundle correctly
    system "#{bin}/antibody", "bundle", "rupa/z"
    assert_match("rupa/z", shell_output("#{bin}/antibody list"))
  end
end
