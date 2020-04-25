class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v2.3.0.tar.gz"
  sha256 "cbe534c57d0e0e17b0a739d71bb0d33a3bc295e65d6d125860bcfc7053abd645"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd8fda7082ca7ee05300442c9f2be9830902d7f4c6302f617a99b8e05b9f2ece" => :catalina
    sha256 "caf26ee29c543067e33d58aaa979e3a63b57b392e748643439766f525fff9622" => :mojave
    sha256 "89872237307d4e37792531ded63106ffed9cc5c35cb0ca5250bdc66bd461b9d7" => :high_sierra
  end

  # To avoid breaking existing git hooks when we update Python,
  # we should never depend on a versioned Python formula and
  # always use the "default".
  depends_on "python"

  def install
    # Make sure we are actually using Homebrew's Python
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'#!/usr/bin/env {py}'",
              "'#!#{Formula["python"].opt_bin}/python3'"

    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "pre-commit"
    venv.pip_install_and_link buildpath
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    testpath.cd do
      system "git", "init"
      (testpath/".pre-commit-config.yaml").write <<~EOS
        -   repo: https://github.com/pre-commit/pre-commit-hooks
            sha: v0.9.1
            hooks:
            -   id: trailing-whitespace
      EOS
      system bin/"pre-commit", "install"
      (testpath/"f").write "hi\n"
      system "git", "add", "f"

      ENV["GIT_AUTHOR_NAME"] = "test user"
      ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
      ENV["GIT_COMMITTER_NAME"] = "test user"
      ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
      git_exe = which("git")
      ENV["PATH"] = "/usr/bin:/bin"
      system git_exe, "commit", "-m", "test"
    end
  end
end
