class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.3.tar.gz"
  sha256 "0d01653613585b6a2c8e473b0e9fbb1103e341788ac59b89288f04ac5ac33bfa"
  head "https://github.com/glandium/git-cinnabar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bacf519a34a5a7da1af722a9c97f98d8882ac526aebdfed6c8c1d493befb9e0" => :catalina
    sha256 "ba3b5616b5f41698df07035ca4fa9ad8cf67b12b7af7cdf2e21383b5ec1a828e" => :mojave
    sha256 "19bfb6524dec8aa39e88fa97a3c8c31a963a223eb8371fab954b41748929e018" => :high_sierra
    sha256 "523598608a6fd6b46682089f6c7c56513ae8933c3a619fa2e59dcc90822e97c1" => :sierra
  end

  depends_on "mercurial"
  uses_from_macos "curl"

  conflicts_with "git-remote-hg", :because => "both install `git-remote-hg` binaries"

  def install
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, :PYTHONPATH => prefix)
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
