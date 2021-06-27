class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.2/pickle.phar"
  sha256 "4fee7dbfe44c93c939fbc7d4b1929a3255e2d042b0e46685dac80a5e181c102e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3f40656f0fd73dc814fdfe25e760934de5c88e2d589cda78d03382a4ac7e0668"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c6cab0f396d7fb92bf9a4c9f34b4ee8270cc7dc90bcbcf3161b85434c877bb8"
    sha256 cellar: :any_skip_relocation, catalina:      "0c6cab0f396d7fb92bf9a4c9f34b4ee8270cc7dc90bcbcf3161b85434c877bb8"
    sha256 cellar: :any_skip_relocation, mojave:        "0c6cab0f396d7fb92bf9a4c9f34b4ee8270cc7dc90bcbcf3161b85434c877bb8"
  end

  depends_on "php"

  def install
    bin.install "pickle.phar" => "pickle"
  end

  test do
    assert_match(/Package name[ |]+apcu/, shell_output("pickle info apcu"))
  end
end
