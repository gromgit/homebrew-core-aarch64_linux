class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.25.1/chapel-1.25.1.tar.gz"
  sha256 "0c13d7da5892d0b6642267af605d808eb7dd5d4970766f262f38b94fa2405113"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "e11d484b8dbeb19649b46ebadb1ff063e79a3fa7c3e1befc258c6fd28a4712a2"
    sha256 arm64_big_sur:  "816fe386b1d8265df2a4af0721fc3ed62d47b7d4f8c6c2e5ddd8c6d060776e42"
    sha256 monterey:       "af7c4e7c0f3204bf63dfe2b2a09d458684cd9e93e64f9f6f25de2c77e81a6edb"
    sha256 big_sur:        "042ea557965c12f0bce8537b87ded0761bd67edd1c358be7cd1ba62a299a80d3"
    sha256 catalina:       "eb1eb04bbeadf0e9868bb2fb1ee79dd28500bca5575a89417471a768826bdd41"
    sha256 x86_64_linux:   "ec01313dd3b0136c6620b7f01298fa0c97f1d4a87a1371402c552064cb8677db"
  end

  depends_on "gmp"
  depends_on "llvm@11"
  depends_on "python@3.9"

  # can be removed after https://github.com/chapel-lang/chapel/pull/18880 merged
  patch :DATA

  def install
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_GMP"] = "system"

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "echo CHPL_RE2=bundled > chplconfig"
      system "echo CHPL_GMP=system >> chplconfig"
      system "echo CHPL_LLVM_CONFIG=#{HOMEBREW_PREFIX}/opt/llvm@11/bin/llvm-config >> chplconfig"
      system "./util/printchplenv", "--all"
      with_env(CHPL_PIP_INSTALL_PARAMS: "--no-binary :all:") do
        system "make", "test-venv"
      end
      with_env(CHPL_LLVM: "none") do
        system "make"
      end
      with_env(CHPL_LLVM: "system") do
        system "make"
      end
      with_env(CHPL_PIP_INSTALL_PARAMS: "--no-binary :all:") do
        system "make", "chpldoc"
      end
      system "make", "mason"
      system "make", "cleanall"
      rm_rf("third-party/llvm/llvm-src/")
      rm_rf("third-party/gasnet/gasnet-src")
      rm_rf("third-party/libfabric/libfabric-src")
      rm_rf("third-party/fltk/fltk-1.3.5-source.tar.gz")
      rm_rf("third-party/libunwind/libunwind-1.1.tar.gz")
      rm_rf("third-party/gmp/gmp-src/")
      rm_rf("third-party/qthread/qthread-src/installed")
    end

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    platform = if OS.linux? && Hardware::CPU.is_64_bit?
      "linux64-#{Hardware::CPU.arch}"
    else
      "#{OS.kernel_name.downcase}-#{Hardware::CPU.arch}"
    end

    bin.install libexec.glob("bin/#{platform}/*")
    bin.env_script_all_files libexec/"bin"/platform, CHPL_HOME: libexec
    man1.install_symlink libexec.glob("man/man1/*.1")
  end

  test do
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_INCLUDE_PATH"] = HOMEBREW_PREFIX/"include"
    ENV["CHPL_LIB_PATH"] = HOMEBREW_PREFIX/"lib"
    cd libexec do
      with_env(CHPL_LLVM: "system") do
        system "util/test/checkChplInstall"
      end
      with_env(CHPL_LLVM: "none") do
        system "util/test/checkChplInstall"
      end
    end
    system bin/"chpl", "--print-passes", "--print-commands", libexec/"examples/hello.chpl"
  end
end

__END__
diff --git a/third-party/chpl-venv/Makefile b/third-party/chpl-venv/Makefile
index eb227b116f..b72c05dc47 100644
--- a/third-party/chpl-venv/Makefile
+++ b/third-party/chpl-venv/Makefile
@@ -24,47 +24,27 @@ OLD_PYTHON_ERROR="python3 version 3.5 or later is required to install chpldoc an
 #  (to allow for a different path to the system python3 in the future)
 $(CHPL_VENV_VIRTUALENV_DIR_OK):
 	@# First check the python version is OK
-	@case `$(PYTHON) --version` in \
-	  *"Python 3.0"*) \
-	    echo $(OLD_PYTHON_ERROR) ; \
-            exit 1 ; \
-	    ;; \
-	  *"Python 3.1"*) \
-	    echo $(OLD_PYTHON_ERROR) ; \
-            exit 1 ; \
-	    ;; \
-	  *"Python 3.2"*) \
-	    echo $(OLD_PYTHON_ERROR) ; \
-            exit 1 ; \
-	    ;; \
-	  *"Python 3.3"*) \
-	    echo $(OLD_PYTHON_ERROR) ; \
-            exit 1 ; \
-	    ;; \
-	  *"Python 3.4"*) \
-	    echo $(OLD_PYTHON_ERROR) ; \
-            exit 1 ; \
-	    ;; \
-	  *"Python 3"*) \
-	    ;; \
-	  *) \
-	    echo $(OLD_PYTHON_ERROR) ; \
-            exit 1 ; \
-	    ;; \
-	esac
+	@if $(PYTHON) -c 'import sys; sys.exit(int(sys.version_info[:2] >= (3, 5)))'; then \
+	  echo $(OLD_PYTHON_ERROR); \
+	  exit 1; \
+	fi
 
 	@# Now create the venv to use to get the dependencies
 	$(PYTHON) -m venv $(CHPL_VENV_VIRTUALENV_DIR)
 	export PATH="$(CHPL_VENV_VIRTUALENV_BIN):$$PATH" && \
 	export VIRTUAL_ENV=$(CHPL_VENV_VIRTUALENV_DIR) && \
-	$(PIP) install \
-	--upgrade $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) wheel && \
+	$(PIP) install --upgrade $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) \
+	  wheel && \
+	$(PIP) install --upgrade $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) \
+	  -r $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE1) && \
+	$(PIP) install --upgrade $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) \
+	  -r $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE2) && \
 	touch $(CHPL_VENV_VIRTUALENV_DIR_OK)
 
 # Phony convenience target for creating virtualenv.
 create-virtualenv: $(CHPL_VENV_VIRTUALENV_DIR_OK)
 
-$(CHPL_VENV_CHPLDEPS_MAIN): $(CHPL_VENV_VIRTUALENV_DIR_OK) $(CHPL_VENV_TEST_REQUIREMENTS_FILE) $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE) $(CHPL_VENV_C2CHAPEL_REQUIREMENTS_FILE) chpldeps-main.py
+$(CHPL_VENV_CHPLDEPS_MAIN): $(CHPL_VENV_VIRTUALENV_DIR_OK) $(CHPL_VENV_TEST_REQUIREMENTS_FILE) $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE1) $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE2) $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE3) $(CHPL_VENV_C2CHAPEL_REQUIREMENTS_FILE) chpldeps-main.py
 	@# Install dependencies to $(CHPL_VENV_CHPLDEPS)
 	@# Rely on pip to create the directory
 	export PATH="$(CHPL_VENV_VIRTUALENV_BIN):$$PATH" && \
@@ -72,7 +52,9 @@ $(CHPL_VENV_CHPLDEPS_MAIN): $(CHPL_VENV_VIRTUALENV_DIR_OK) $(CHPL_VENV_TEST_REQU
 	$(PIP) install --upgrade $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) \
 	  --target $(CHPL_VENV_CHPLDEPS) \
 	  -r $(CHPL_VENV_TEST_REQUIREMENTS_FILE) \
-	  -r $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE) \
+	  -r $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE1) \
+	  -r $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE2) \
+	  -r $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE3) \
 	  -r $(CHPL_VENV_C2CHAPEL_REQUIREMENTS_FILE) && \
 	cp chpldeps-main.py $(CHPL_VENV_CHPLDEPS_MAIN)
 
@@ -89,8 +71,7 @@ install-requirements: install-chpldeps
 $(CHPL_VENV_CHPLSPELL_REQS): $(CHPL_VENV_VIRTUALENV_DIR_OK) $(CHPL_VENV_CHPLSPELL_REQUIREMENTS_FILE)
 	export PATH="$(CHPL_VENV_VIRTUALENV_BIN):$$PATH" && \
 	export VIRTUAL_ENV=$(CHPL_VENV_VIRTUALENV_DIR) && \
-	$(PIP) install \
-	  --upgrade $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) \
+	$(PIP) install --upgrade $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) \
 	  -r $(CHPL_VENV_CHPLSPELL_REQUIREMENTS_FILE) && \
 	touch $(CHPL_VENV_CHPLSPELL_REQS)
 
diff --git a/third-party/chpl-venv/Makefile.include b/third-party/chpl-venv/Makefile.include
index c5dbed5700..9ef60a02e1 100644
--- a/third-party/chpl-venv/Makefile.include
+++ b/third-party/chpl-venv/Makefile.include
@@ -6,7 +6,9 @@
 CHPL_VENV_DIR=$(shell cd $(THIRD_PARTY_DIR)/chpl-venv && pwd)
 
 CHPL_VENV_TEST_REQUIREMENTS_FILE=$(CHPL_VENV_DIR)/test-requirements.txt
-CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE=$(CHPL_VENV_DIR)/chpldoc-requirements.txt
+CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE1=$(CHPL_VENV_DIR)/chpldoc-requirements1.txt
+CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE2=$(CHPL_VENV_DIR)/chpldoc-requirements2.txt
+CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE3=$(CHPL_VENV_DIR)/chpldoc-requirements3.txt
 CHPL_VENV_C2CHAPEL_REQUIREMENTS_FILE=$(CHPL_VENV_DIR)/c2chapel-requirements.txt
 
 CHPL_VENV_CHPLSPELL_REQUIREMENTS_FILE=$(CHPL_VENV_DIR)/chplspell-requirements.txt
diff --git a/third-party/chpl-venv/chpldoc-requirements.txt b/third-party/chpl-venv/chpldoc-requirements.txt
index 864a42a56e..c063b1011a 100644
--- a/third-party/chpl-venv/chpldoc-requirements.txt
+++ b/third-party/chpl-venv/chpldoc-requirements.txt
@@ -3,7 +3,7 @@ MarkupSafe==2.0.1
 Pygments==2.9.0
 Sphinx==4.0.2
 docutils==0.16.0
-sphinx-rtd-theme==0.5.2
+sphinx-rtd-theme==1.0.0
 sphinxcontrib-chapeldomain==0.0.20
 babel==2.9.1
 breathe==4.30.0
diff --git a/third-party/chpl-venv/chpldoc-requirements1.txt b/third-party/chpl-venv/chpldoc-requirements1.txt
new file mode 100644
index 0000000000..c3025d5c0f
--- /dev/null
+++ b/third-party/chpl-venv/chpldoc-requirements1.txt
@@ -0,0 +1 @@
+MarkupSafe==2.0.1
diff --git a/third-party/chpl-venv/chpldoc-requirements2.txt b/third-party/chpl-venv/chpldoc-requirements2.txt
new file mode 100644
index 0000000000..519cf147c4
--- /dev/null
+++ b/third-party/chpl-venv/chpldoc-requirements2.txt
@@ -0,0 +1,5 @@
+Jinja2==3.0.1
+Pygments==2.9.0
+Sphinx==4.0.2
+docutils==0.16.0
+babel==2.9.1
diff --git a/third-party/chpl-venv/chpldoc-requirements3.txt b/third-party/chpl-venv/chpldoc-requirements3.txt
new file mode 100644
index 0000000000..ba1b71fbf7
--- /dev/null
+++ b/third-party/chpl-venv/chpldoc-requirements3.txt
@@ -0,0 +1,3 @@
+sphinx-rtd-theme==1.0.0
+sphinxcontrib-chapeldomain==0.0.20
+breathe==4.30.0
diff --git a/util/chplenv/chpl_llvm.py b/util/chplenv/chpl_llvm.py
index 99e918e947..a16ca37fb7 100755
--- a/util/chplenv/chpl_llvm.py
+++ b/util/chplenv/chpl_llvm.py
@@ -110,6 +110,10 @@ def check_llvm_config(llvm_config):
 
 @memoize
 def find_system_llvm_config():
+    llvm_config = overrides.get('CHPL_LLVM_CONFIG', 'none')
+    if llvm_config != 'none':
+        return llvm_config
+
     paths = [ ]
     for vers in llvm_versions():
         paths.append("llvm-config-" + vers + ".0")
@@ -402,12 +406,16 @@ def get_clang_additional_args():
         if arg == '-isysroot':
             has_sysroot = True
 
-    if has_sysroot:
-        # Work around a bug in some versions of Clang that forget to
+    # Check to see if Homebrew is installed. If it is,
+    # add the result of `brew prefix` to -I and -L args.
+    exists, retcode, my_out, my_err = try_run_command(['brew', '--prefix'])
+    if exists and retcode == 0:
+        # Make sure to include homebrew search path
+        homebrew_prefix = my_out.strip()
         # search /usr/local/include and /usr/local/lib
         # if there is a -isysroot argument.
-        comp_args.append('-I/usr/local/include')
-        link_args.append('-L/usr/local/lib')
+        comp_args.append('-I' + homebrew_prefix + '/include')
+        link_args.append('-L' + homebrew_prefix + '/lib')
 
     return (comp_args, link_args)
 
