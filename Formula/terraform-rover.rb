require "language/node"
class TerraformRover < Formula
  desc "Terraform Visualizer"
  homepage "https://github.com/im2nguyen/rover"
  url "https://github.com/im2nguyen/rover/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "91dc4ff26e0adafde011db1e6111a8a3c545cddbae1a70c8f4c3abc484b0be0b"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3412ce96504fca6f97e7d041c06ea24a83969e03e0a5881b17196821c9a4d14e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cb3a9c5cc5f962b6cba348de4223ed38d43447ab7d7b1e307de00aa8c83154f"
    sha256 cellar: :any_skip_relocation, monterey:       "0e6f0533ac17e4171553c1c3451beef2efe7520cabe2e79738312fa2dcdeab0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "57d45f46ff3c9a782680138a46ce2de96e784f40492dda446f3181d6279c969b"
    sha256 cellar: :any_skip_relocation, catalina:       "37d1af5fad6d3192ba56c1b6ae2b8c0da9f20b96d3f0c09a840d00bd5ef80095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2186246152a9c36aaf4cbdb54b51ad37bceedca3e268131df54c06e053a43ac5"
  end

  depends_on "go" => :build
  depends_on "node"
  depends_on "terraform"

  # Update terraform components, remove in next version
  patch do
    url "https://github.com/im2nguyen/rover/commit/a2a1e57ffcbedcc9a8d39c2696d4cee84eec8cd6.patch?full_index=1"
    sha256 "d085834625def68e9ebaaee89a6d077fba12220df5347529412f82c9cc69d7cd"
  end

  def install
    Language::Node.setup_npm_environment
    cd "ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"main.tf").write <<~EOS
      output "hello_world" {
        value = "Hello, World!"
      }
    EOS
    system bin/"terraform-rover", "-standalone", "-tfPath", Formula["terraform"].bin/"terraform"
    assert_predicate testpath/"rover.zip", :exist?
  end
end
