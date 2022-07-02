class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/b7/4c/e99264b9f39e447e5077840037c8bb9e7ef7cd49de4c8646654b83dbbdfb/all_repos-1.23.0.tar.gz"
  sha256 "5ecba787dfbacd45632cfcba53ab01a1d81a52633ceb7555a0f81d1325fdcc70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb54b0ca6c34163f7dfb0b0637834c4e2f638aa9d7a713387950bca943fdeb91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb54b0ca6c34163f7dfb0b0637834c4e2f638aa9d7a713387950bca943fdeb91"
    sha256 cellar: :any_skip_relocation, monterey:       "d4924a02371c783d2ad14653aeb8c23baf772657a7ec7c4e206f84fc74156b43"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4924a02371c783d2ad14653aeb8c23baf772657a7ec7c4e206f84fc74156b43"
    sha256 cellar: :any_skip_relocation, catalina:       "d4924a02371c783d2ad14653aeb8c23baf772657a7ec7c4e206f84fc74156b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40d6d9f6aa0e09635e744d9e7ff7967fff79ddcd21e8a17249e98d4ddbbeba8e"
  end

  depends_on "python@3.10"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/e5/8e/408d590e26fbc75a2e974aa1103d95a3ffef014209967f66f491306c4824/identify-2.5.1.tar.gz"
    sha256 "3d11b16f3fe19f52039fb7e39c9c884b21cb1b586988114fbe42671f03de3e82"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"all-repos.json").write <<~EOS
      {
        "output_dir": ".",
        "source": "all_repos.source.json_file",
        "source_settings": {"filename": "repos.json"},
        "push": "all_repos.push.readonly",
        "push_settings": {}
      }
    EOS
    chmod 0600, "all-repos.json"
    (testpath/"repos.json").write <<~EOS
      {"discussions": "https://github.com/Homebrew/discussions"}
    EOS

    system "all-repos-clone"
    assert_predicate testpath/"discussions", :exist?
    output = shell_output("#{bin}/all-repos-grep discussions")
    assert_match "./discussions:README.md", output
  end
end
