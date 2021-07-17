require "language/node"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.29.0.tgz"
  sha256 "bb78145a780dbcd5cbe720b10f4023bb2fcfde977847d09162e40f62766a2f39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "08a7c339b0b3b35d4f7a6973323ba0e11569cf305c278bf7ee29da060c2e2ad6"
    sha256 cellar: :any_skip_relocation, all:          "990f7be8de80e67b76e5000d560137e24833c70fa7b43327e0d0434111c3442d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"input.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"ncc", "build", "input.js", "-o", "dist"
    assert_match "document.createElement", File.read("dist/index.js")
  end
end
