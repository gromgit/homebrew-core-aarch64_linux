class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.9/pickle.phar"
  sha256 "e3f787deb31862cdf3b301a08a1a3c46e311c8e1cab7a177b70983de87d2d2e9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f92264746e31b4662f471d8d8e0814c13dae489bb4f165892fa04d73d5fae52e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f92264746e31b4662f471d8d8e0814c13dae489bb4f165892fa04d73d5fae52e"
    sha256 cellar: :any_skip_relocation, monterey:       "51d6afa3b67522abc34f47ceeaf6b55f5eb8a98276fd1bac69649d66a00b3ecb"
    sha256 cellar: :any_skip_relocation, big_sur:        "51d6afa3b67522abc34f47ceeaf6b55f5eb8a98276fd1bac69649d66a00b3ecb"
    sha256 cellar: :any_skip_relocation, catalina:       "51d6afa3b67522abc34f47ceeaf6b55f5eb8a98276fd1bac69649d66a00b3ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f92264746e31b4662f471d8d8e0814c13dae489bb4f165892fa04d73d5fae52e"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    bin.install "pickle.phar" => "pickle"
  end

  test do
    assert_match(/Package name[ |]+apcu/, shell_output("pickle info apcu"))
  end
end
