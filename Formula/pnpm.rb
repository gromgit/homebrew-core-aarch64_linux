class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.14.1.tgz"
  sha256 "4ed17ac4706ed9f7818d40cb893d0c3a8b07927f1628ef9e15ff8fb689be27b0"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "98aa6e906837e49c1941fd90678fb0cfe738d8d5caeee8b0880f03acb538249e" => :big_sur
    sha256 "ace839c620622bd4fbfaca3d1b110b790abdecbb7fe403ca850ff15c706f50cc" => :arm64_big_sur
    sha256 "e76e31ac6d87291971c98bcf741e60eb41b0d6e486553462adeb38608cc0893f" => :catalina
    sha256 "642f3a15f9065c4cce643bce6bf8f8252ec4168ac1a825c48cb04c68ef1edc1c" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
