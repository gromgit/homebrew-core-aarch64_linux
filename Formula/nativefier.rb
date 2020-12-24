require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-42.0.2.tgz"
  sha256 "bdea516de445deabcd7e1decb7e69a7f2153f78173e08afda212918a05c590f2"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7d421d5483813150206e73225702ff5beba8b6d28a347eec9a149f064502cd7a" => :big_sur
    sha256 "15a2b779a84d1c20bd792dd037a4f03a79eddc1b170f0898b0186ad7dd342aad" => :arm64_big_sur
    sha256 "579864e4179cdc08b88bb59802e1cabb6fa8decd5f7c39d6fa5d6127c3934a9c" => :catalina
    sha256 "9f3ff10f644eb28f2beaab8bc08ee6e0ebcd6aae813c4b52aa4cdef26d665cde" => :mojave
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
