// Copyright (c) 2018, Cyberhaven
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import com.cloudbees.plugins.credentials.CredentialsScope
import com.cloudbees.plugins.credentials.domains.Domain
import hudson.util.Secret
import org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl

// Store the github token in the credentials store
def credId = 'github-token'
def token = new File("/run/secrets/jenkins-github-token").text.trim()

def domain = Domain.global()
def instance = jenkins.model.Jenkins.instance
def extensions = instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')
def store = extensions[0].getStore()

if (store.getCredentials(domain).find { it.id == credId } == null) {
  def secretText = new StringCredentialsImpl(
          CredentialsScope.GLOBAL,
          credId,
          "Github Personal Token for s2e-ci user" as String,
          Secret.fromString(token)
  )
  store.addCredentials(domain, secretText)
}
