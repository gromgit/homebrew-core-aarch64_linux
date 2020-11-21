require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-11.0.2.tgz"
  sha256 "1a4d68564a8f6874f0cdbf04723c800d078c69a37b7d8588a059f37c8acafa3f"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9ba34efb8b7ef418e43a0e17e5a2387d843e5a611b9f00c0c0523dc4e446d115" => :big_sur
    sha256 "5faf6ac1c7958dc8211d885d33ed8a16f50222c90f34bb42aa29d8d5ec4dfc05" => :catalina
    sha256 "f24f654d9c817a4c5773a8256843f517691c44e5e624a211ff674afcf99f141b" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
