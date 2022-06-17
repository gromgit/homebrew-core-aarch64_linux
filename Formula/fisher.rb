class Fisher < Formula
  desc "Plugin manager for the Fish shell"
  homepage "https://github.com/jorgebucaran/fisher"
  url "https://github.com/jorgebucaran/fisher/archive/4.3.3.tar.gz"
  sha256 "b587ae3a931c9efea13322be09092b7a96ad490f4947e21b03a99d41b8dd86cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "48e107b311077594f35dfb6d69eea55bd5b49ecda7617ab900cc4b749455f418"
  end

  depends_on "fish"

  def install
    fish_function.install "functions/fisher.fish"
    fish_completion.install "completions/fisher.fish"
  end

  test do
    system "#{Formula["fish"].bin}/fish", "-c", "fisher install jethrokuan/z"
    assert_equal File.read(testpath/".config/fish/fish_plugins"), "jethrokuan/z\n"
  end
end
